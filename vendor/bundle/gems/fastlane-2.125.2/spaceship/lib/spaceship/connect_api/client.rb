require_relative '../client'
require_relative './response'

module Spaceship
  # rubocop:disable Metrics/ClassLength
  module ConnectAPI
    class Client < Spaceship::Client
      ##
      # Spaceship HTTP client for the App Store Connect API.
      #
      # This client is solely responsible for the making HTTP requests and
      # parsing their responses. Parameters should be either named parameters, or
      # for large request data bodies, pass in anything that can resond to
      # `to_json`.
      #
      # Each request method should validate the required parameters. A required parameter is one that would result in 400-range response if it is not supplied.
      # Each request method should make only one request. For more high-level logic, put code in the data models.

      def self.hostname
        'https://appstoreconnect.apple.com/iris/v1/'
      end

      #
      # Helpers
      #

      def build_params(filter: nil, includes: nil, limit: nil, sort: nil, cursor: nil)
        params = {}

        filter = filter.delete_if { |k, v| v.nil? } if filter

        params[:filter] = filter if filter && !filter.empty?
        params[:include] = includes if includes
        params[:limit] = limit if limit
        params[:sort] = sort if sort
        params[:cursor] = cursor if cursor

        return params
      end

      def get(url_or_path, params = nil)
        response = request(:get) do |req|
          req.url(url_or_path)
          req.options.params_encoder = Faraday::NestedParamsEncoder
          req.params = params if params
        end
        handle_response(response)
      end

      def post(url_or_path, body)
        response = request(:post) do |req|
          req.url(url_or_path)
          req.body = body.to_json
          req.headers['Content-Type'] = 'application/json'
        end
        handle_response(response)
      end

      def patch(url_or_path, body)
        response = request(:patch) do |req|
          req.url(url_or_path)
          req.body = body.to_json
          req.headers['Content-Type'] = 'application/json'
        end
        handle_response(response)
      end

      def delete(url_or_path, params = nil, body = nil)
        response = request(:delete) do |req|
          req.url(url_or_path)
          req.options.params_encoder = Faraday::NestedParamsEncoder if params
          req.params = params if params
          req.body = body.to_json if body
          req.headers['Content-Type'] = 'application/json' if body
        end
        handle_response(response)
      end

      #
      # apps
      #

      def get_apps(filter: {}, includes: nil, limit: nil, sort: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/apps
        params = build_params(filter: filter, includes: includes, limit: limit, sort: sort)
        get("apps", params)
      end

      def get_app(app_id: nil, includes: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/apps/<app_id>
        params = build_params(filter: nil, includes: includes, limit: nil, sort: nil)
        get("apps/#{app_id}", params)
      end

      #
      # betaAppLocalizations
      #

      def get_beta_app_localizations(filter: {}, includes: nil, limit: nil, sort: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/betaAppLocalizations?filter[app]=<app_id>
        params = build_params(filter: filter, includes: includes, limit: limit, sort: sort)
        get("betaAppLocalizations", params)
      end

      def post_beta_app_localizations(app_id: nil, attributes: {})
        # POST
        # https://appstoreconnect.apple.com/iris/v1/betaAppLocalizations
        path = "betaAppLocalizations"

        body = {
          data: {
            attributes: attributes,
            type: "betaAppLocalizations",
            relationships: {
              app: {
                data: {
                  type: "apps",
                  id: app_id
                }
              }
            }
          }
        }

        post(path, body)
      end

      def patch_beta_app_localizations(localization_id: nil, attributes: {})
        # PATCH
        # https://appstoreconnect.apple.com/iris/v1/apps/<app_id>/betaAppLocalizations/<localization_id>
        path = "betaAppLocalizations/#{localization_id}"

        body = {
          data: {
            attributes: attributes,
            id: localization_id,
            type: "betaAppLocalizations"
          }
        }

        patch(path, body)
      end

      #
      # betaAppReviewDetails
      #

      def get_beta_app_review_detail(filter: {}, includes: nil, limit: nil, sort: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/betaAppReviewDetails?filter[app]=<app_id>
        params = build_params(filter: filter, includes: includes, limit: limit, sort: sort)
        get("betaAppReviewDetails", params)
      end

      def patch_beta_app_review_detail(app_id: nil, attributes: {})
        # PATCH
        # https://appstoreconnect.apple.com/iris/v1/apps/<app_id>/betaAppReviewDetails
        path = "betaAppReviewDetails/#{app_id}"

        body = {
          data: {
            attributes: attributes,
            id: app_id,
            type: "betaAppReviewDetails"
          }
        }

        patch(path, body)
      end

      #
      # betaAppReviewSubmissions
      #

      def get_beta_app_review_submissions(filter: {}, includes: nil, limit: nil, sort: nil, cursor: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/betaAppReviewSubmissions
        params = build_params(filter: filter, includes: includes, limit: limit, sort: sort, cursor: cursor)
        get("betaAppReviewSubmissions", params)
      end

      def post_beta_app_review_submissions(build_id: nil)
        # POST
        # https://appstoreconnect.apple.com/iris/v1/betaAppReviewSubmissions
        path = "betaAppReviewSubmissions"
        body = {
          data: {
            type: "betaAppReviewSubmissions",
            relationships: {
              build: {
                data: {
                  type: "builds",
                  id: build_id
                }
              }
            }
          }
        }

        post(path, body)
      end

      def delete_beta_app_review_submission(beta_app_review_submission_id: nil)
        # DELETE
        # https://appstoreconnect.apple.com/iris/v1/betaAppReviewSubmissions/<beta_app_review_submission_id>
        params = build_params(filter: nil, includes: nil, limit: nil, sort: nil, cursor: nil)
        delete("betaAppReviewSubmissions/#{beta_app_review_submission_id}", params)
      end

      #
      # betaBuildLocalizations
      #

      def get_beta_build_localizations(filter: {}, includes: nil, limit: nil, sort: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/betaBuildLocalizations
        path = "betaBuildLocalizations"
        params = build_params(filter: filter, includes: includes, limit: limit, sort: sort)
        get(path, params)
      end

      def post_beta_build_localizations(build_id: nil, attributes: {})
        # POST
        # https://appstoreconnect.apple.com/iris/v1/betaBuildLocalizations
        path = "betaBuildLocalizations"

        body = {
          data: {
            attributes: attributes,
            type: "betaBuildLocalizations",
            relationships: {
              build: {
                data: {
                  type: "builds",
                  id: build_id
                }
              }
            }
          }
        }

        post(path, body)
      end

      def patch_beta_build_localizations(localization_id: nil, feedbackEmail: nil, attributes: {})
        # PATCH
        # https://appstoreconnect.apple.com/iris/v1/apps/<app_id>/betaBuildLocalizations
        path = "betaBuildLocalizations/#{localization_id}"

        body = {
          data: {
            attributes: attributes,
            id: localization_id,
            type: "betaBuildLocalizations"
          }
        }

        patch(path, body)
      end

      #
      # betaBuildMetrics
      #

      def get_beta_build_metrics(filter: {}, includes: nil, limit: nil, sort: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/betaBuildMetrics
        params = build_params(filter: filter, includes: includes, limit: limit, sort: sort)
        get("betaBuildMetrics", params)
      end

      #
      # betaGroups
      #

      def get_beta_groups(filter: {}, includes: nil, limit: nil, sort: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/betaGroups
        params = build_params(filter: filter, includes: includes, limit: limit, sort: sort)
        get("betaGroups", params)
      end

      def add_beta_groups_to_build(build_id: nil, beta_group_ids: [])
        # POST
        # https://appstoreconnect.apple.com/iris/v1/builds/<build_id>/relationships/betaGroups
        path = "builds/#{build_id}/relationships/betaGroups"
        body = {
          data: beta_group_ids.map do |id|
            {
              type: "betaGroups",
              id: id
            }
          end
        }

        post(path, body)
      end

      #
      # betaTesters
      #

      def get_beta_testers(filter: {}, includes: nil, limit: nil, sort: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/betaTesters
        params = build_params(filter: filter, includes: includes, limit: limit, sort: sort)
        get("betaTesters", params)
      end

      # beta_testers - [{email: "", firstName: "", lastName: ""}]
      def post_bulk_beta_tester_assignments(beta_group_id: nil, beta_testers: nil)
        # POST
        # https://appstoreconnect.apple.com/iris/v1/bulkBetaTesterAssignments
        beta_testers || []

        beta_testers.map do |tester|
          tester[:errors] = []
        end

        body = {
          data: {
            attributes: {
              betaTesters: beta_testers
            },
            relationships: {
              betaGroup: {
                data: {
                  type: "betaGroups",
                  id: beta_group_id
                }
              }
            },
            type: "bulkBetaTesterAssignments"
          }
        }

        post("bulkBetaTesterAssignments", body)
      end

      def delete_beta_tester_from_apps(beta_tester_id: nil, app_ids: [])
        # DELETE
        # https://appstoreconnect.apple.com/iris/v1/betaTesters/<beta_tester_id>/relationships/apps
        path = "betaTesters/#{beta_tester_id}/relationships/apps"
        body = {
          data: app_ids.map do |id|
            {
              type: "apps",
              id: id
            }
          end
        }

        delete(path, nil, body)
      end

      def delete_beta_tester_from_beta_groups(beta_tester_id: nil, beta_group_ids: [])
        # DELETE
        # https://appstoreconnect.apple.com/iris/v1/betaTesters/<beta_tester_id>/relationships/betaGroups
        path = "betaTesters/#{beta_tester_id}/relationships/betaGroups"
        body = {
          data: beta_group_ids.map do |id|
            {
              type: "betaGroups",
              id: id
            }
          end
        }

        delete(path, nil, body)
      end

      #
      # betaTesterMetrics
      #

      def get_beta_tester_metrics(filter: {}, includes: nil, limit: nil, sort: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/betaTesterMetrics
        params = build_params(filter: filter, includes: includes, limit: limit, sort: sort)
        get("betaTesterMetrics", params)
      end

      #
      # builds
      #

      def get_builds(filter: {}, includes: "buildBetaDetail,betaBuildMetrics", limit: 10, sort: "uploadedDate", cursor: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/builds
        params = build_params(filter: filter, includes: includes, limit: limit, sort: sort, cursor: cursor)
        get("builds", params)
      end

      def get_build(build_id: nil, includes: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/builds/<build_id>?
        params = build_params(filter: nil, includes: includes, limit: nil, sort: nil, cursor: nil)
        get("builds/#{build_id}", params)
      end

      def patch_builds(build_id: nil, attributes: {})
        # PATCH
        # https://appstoreconnect.apple.com/iris/v1/builds/<build_id>
        path = "builds/#{build_id}"

        body = {
          data: {
            attributes: attributes,
            id: build_id,
            type: "builds"
          }
        }

        patch(path, body)
      end

      #
      # buildBetaDetails
      #

      def get_build_beta_details(filter: {}, includes: nil, limit: nil, sort: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/buildBetaDetails
        params = build_params(filter: filter, includes: includes, limit: limit, sort: sort)
        get("buildBetaDetails", params)
      end

      def patch_build_beta_details(build_beta_details_id: nil, attributes: {})
        # PATCH
        # https://appstoreconnect.apple.com/iris/v1/buildBetaDetails/<build_beta_details_id>
        path = "buildBetaDetails/#{build_beta_details_id}"

        body = {
          data: {
            attributes: attributes,
            id: build_beta_details_id,
            type: "buildBetaDetails"
          }
        }

        patch(path, body)
      end

      #
      # buildDeliveries
      #

      def get_build_deliveries(filter: {}, includes: nil, limit: nil, sort: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/buildDeliveries
        params = build_params(filter: filter, includes: includes, limit: limit, sort: sort)
        get("buildDeliveries", params)
      end

      #
      # preReleaseVersions
      #

      def get_pre_release_versions(filter: {}, includes: nil, limit: nil, sort: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/preReleaseVersions
        params = build_params(filter: filter, includes: includes, limit: limit, sort: sort)
        get("preReleaseVersions", params)
      end

      #
      # users
      #

      def get_users(filter: {}, includes: nil, limit: nil, sort: nil)
        # GET
        # https://appstoreconnect.apple.com/iris/v1/users
        params = build_params(filter: filter, includes: includes, limit: limit, sort: sort)
        get("users", params)
      end

      protected

      def handle_response(response)
        if (200...300).cover?(response.status) && (response.body.nil? || response.body.empty?)
          return
        end

        raise InternalServerError, "Server error got #{response.status}" if (500...600).cover?(response.status)

        unless response.body.kind_of?(Hash)
          raise UnexpectedResponse, response.body
        end

        raise UnexpectedResponse, response.body['error'] if response.body['error']

        raise UnexpectedResponse, handle_errors(response) if response.body['errors']

        raise UnexpectedResponse, "Temporary App Store Connect error: #{response.body}" if response.body['statusCode'] == 'ERROR'

        return Spaceship::ConnectAPI::Response.new(body: response.body, status: response.status)
      end

      def handle_errors(response)
        # Example error format
        # {
        #   "errors" : [ {
        #     "id" : "ce8c391e-f858-411b-a14b-5aa26e0915f2",
        #     "status" : "400",
        #     "code" : "PARAMETER_ERROR.INVALID",
        #     "title" : "A parameter has an invalid value",
        #     "detail" : "'uploadedDate3' is not a valid field name",
        #     "source" : {
        #       "parameter" : "sort"
        #     }
        #   } ]
        # }

        return response.body['errors'].map do |error|
          "#{error['title']} - #{error['detail']}"
        end.join(" ")
      end

      private

      # used to assert all of the named parameters are supplied values
      #
      # @raises NameError if the values are nil
      def assert_required_params(method_name, binding)
        parameter_names = method(method_name).parameters.map { |_, v| v }
        parameter_names.each do |name|
          if local_variable_get(binding, name).nil?
            raise NameError, "`#{name}' is a required parameter"
          end
        end
      end

      def local_variable_get(binding, name)
        if binding.respond_to?(:local_variable_get)
          binding.local_variable_get(name)
        else
          binding.eval(name.to_s)
        end
      end

      def provider_id
        return team_id if self.provider.nil?
        self.provider.provider_id
      end
    end
  end
  # rubocop:enable Metrics/ClassLength
end
