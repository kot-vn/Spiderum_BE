module Api
  module V1
    module User1
      class ReportsController < ApplicationController
        before_action :authorize, only: [:create, :index]
        before_action :admin_user, only: [:index]
        before_action :find_reportable

        def index
          reports = Report.all
          @pagy, @reports = pagy(reports)
          render ({ meta: meta_data, json: @reports, adapter: :json, each_serializer: ReportSerializer }), status: :ok
        end

        def create
          @report = @reportable.reports.build(report_params)
          @report.user_id = @current_user.id
          if @report.save
            @reportable.user.update(report_count: @reportable.user.report_count + 1)
            render json: @report, status: :ok
          else
            render json: @report.errors.full_messages, status: :unprocessable_entity
          end
        end

        private

        def find_reportable
          if params[:comment_id]
            @reportable = Comment.find_by_id(params[:comment_id])
          elsif params[:post_id]
            @reportable = Post.find_by_id(params[:post_id])
          end
        end

        def report_params
          params.permit(:reason)
        end
      end
    end
  end
end
