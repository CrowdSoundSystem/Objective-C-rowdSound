// Generated by the gRPC protobuf plugin.
// If you make any local change, they will be lost.
// source: route_guide.proto
#ifndef GRPC_route_5fguide_2eproto__INCLUDED
#define GRPC_route_5fguide_2eproto__INCLUDED

#include "route_guide.pb.h"

#include <grpc++/support/async_stream.h>
#include <grpc++/impl/rpc_method.h>
#include <grpc++/impl/proto_utils.h>
#include <grpc++/impl/service_type.h>
#include <grpc++/support/async_unary_call.h>
#include <grpc++/support/status.h>
#include <grpc++/support/stub_options.h>
#include <grpc++/support/sync_stream.h>

namespace grpc {
class CompletionQueue;
class Channel;
class RpcService;
class ServerCompletionQueue;
class ServerContext;
}  // namespace grpc

namespace routeguide {

class RouteGuide GRPC_FINAL {
 public:
  class StubInterface {
   public:
    virtual ~StubInterface() {}
    virtual ::grpc::Status GetFeature(::grpc::ClientContext* context, const ::routeguide::Point& request, ::routeguide::Feature* response) = 0;
    std::unique_ptr< ::grpc::ClientAsyncResponseReaderInterface< ::routeguide::Feature>> AsyncGetFeature(::grpc::ClientContext* context, const ::routeguide::Point& request, ::grpc::CompletionQueue* cq) {
      return std::unique_ptr< ::grpc::ClientAsyncResponseReaderInterface< ::routeguide::Feature>>(AsyncGetFeatureRaw(context, request, cq));
    }
    std::unique_ptr< ::grpc::ClientReaderInterface< ::routeguide::Feature>> ListFeatures(::grpc::ClientContext* context, const ::routeguide::Rectangle& request) {
      return std::unique_ptr< ::grpc::ClientReaderInterface< ::routeguide::Feature>>(ListFeaturesRaw(context, request));
    }
    std::unique_ptr< ::grpc::ClientAsyncReaderInterface< ::routeguide::Feature>> AsyncListFeatures(::grpc::ClientContext* context, const ::routeguide::Rectangle& request, ::grpc::CompletionQueue* cq, void* tag) {
      return std::unique_ptr< ::grpc::ClientAsyncReaderInterface< ::routeguide::Feature>>(AsyncListFeaturesRaw(context, request, cq, tag));
    }
    std::unique_ptr< ::grpc::ClientWriterInterface< ::routeguide::Point>> RecordRoute(::grpc::ClientContext* context, ::routeguide::RouteSummary* response) {
      return std::unique_ptr< ::grpc::ClientWriterInterface< ::routeguide::Point>>(RecordRouteRaw(context, response));
    }
    std::unique_ptr< ::grpc::ClientAsyncWriterInterface< ::routeguide::Point>> AsyncRecordRoute(::grpc::ClientContext* context, ::routeguide::RouteSummary* response, ::grpc::CompletionQueue* cq, void* tag) {
      return std::unique_ptr< ::grpc::ClientAsyncWriterInterface< ::routeguide::Point>>(AsyncRecordRouteRaw(context, response, cq, tag));
    }
    std::unique_ptr< ::grpc::ClientReaderWriterInterface< ::routeguide::RouteNote, ::routeguide::RouteNote>> RouteChat(::grpc::ClientContext* context) {
      return std::unique_ptr< ::grpc::ClientReaderWriterInterface< ::routeguide::RouteNote, ::routeguide::RouteNote>>(RouteChatRaw(context));
    }
    std::unique_ptr< ::grpc::ClientAsyncReaderWriterInterface< ::routeguide::RouteNote, ::routeguide::RouteNote>> AsyncRouteChat(::grpc::ClientContext* context, ::grpc::CompletionQueue* cq, void* tag) {
      return std::unique_ptr< ::grpc::ClientAsyncReaderWriterInterface< ::routeguide::RouteNote, ::routeguide::RouteNote>>(AsyncRouteChatRaw(context, cq, tag));
    }
  private:
    virtual ::grpc::ClientAsyncResponseReaderInterface< ::routeguide::Feature>* AsyncGetFeatureRaw(::grpc::ClientContext* context, const ::routeguide::Point& request, ::grpc::CompletionQueue* cq) = 0;
    virtual ::grpc::ClientReaderInterface< ::routeguide::Feature>* ListFeaturesRaw(::grpc::ClientContext* context, const ::routeguide::Rectangle& request) = 0;
    virtual ::grpc::ClientAsyncReaderInterface< ::routeguide::Feature>* AsyncListFeaturesRaw(::grpc::ClientContext* context, const ::routeguide::Rectangle& request, ::grpc::CompletionQueue* cq, void* tag) = 0;
    virtual ::grpc::ClientWriterInterface< ::routeguide::Point>* RecordRouteRaw(::grpc::ClientContext* context, ::routeguide::RouteSummary* response) = 0;
    virtual ::grpc::ClientAsyncWriterInterface< ::routeguide::Point>* AsyncRecordRouteRaw(::grpc::ClientContext* context, ::routeguide::RouteSummary* response, ::grpc::CompletionQueue* cq, void* tag) = 0;
    virtual ::grpc::ClientReaderWriterInterface< ::routeguide::RouteNote, ::routeguide::RouteNote>* RouteChatRaw(::grpc::ClientContext* context) = 0;
    virtual ::grpc::ClientAsyncReaderWriterInterface< ::routeguide::RouteNote, ::routeguide::RouteNote>* AsyncRouteChatRaw(::grpc::ClientContext* context, ::grpc::CompletionQueue* cq, void* tag) = 0;
  };
  class Stub GRPC_FINAL : public StubInterface {
   public:
    Stub(const std::shared_ptr< ::grpc::Channel>& channel);
    ::grpc::Status GetFeature(::grpc::ClientContext* context, const ::routeguide::Point& request, ::routeguide::Feature* response) GRPC_OVERRIDE;
    std::unique_ptr< ::grpc::ClientAsyncResponseReader< ::routeguide::Feature>> AsyncGetFeature(::grpc::ClientContext* context, const ::routeguide::Point& request, ::grpc::CompletionQueue* cq) {
      return std::unique_ptr< ::grpc::ClientAsyncResponseReader< ::routeguide::Feature>>(AsyncGetFeatureRaw(context, request, cq));
    }
    std::unique_ptr< ::grpc::ClientReader< ::routeguide::Feature>> ListFeatures(::grpc::ClientContext* context, const ::routeguide::Rectangle& request) {
      return std::unique_ptr< ::grpc::ClientReader< ::routeguide::Feature>>(ListFeaturesRaw(context, request));
    }
    std::unique_ptr< ::grpc::ClientAsyncReader< ::routeguide::Feature>> AsyncListFeatures(::grpc::ClientContext* context, const ::routeguide::Rectangle& request, ::grpc::CompletionQueue* cq, void* tag) {
      return std::unique_ptr< ::grpc::ClientAsyncReader< ::routeguide::Feature>>(AsyncListFeaturesRaw(context, request, cq, tag));
    }
    std::unique_ptr< ::grpc::ClientWriter< ::routeguide::Point>> RecordRoute(::grpc::ClientContext* context, ::routeguide::RouteSummary* response) {
      return std::unique_ptr< ::grpc::ClientWriter< ::routeguide::Point>>(RecordRouteRaw(context, response));
    }
    std::unique_ptr< ::grpc::ClientAsyncWriter< ::routeguide::Point>> AsyncRecordRoute(::grpc::ClientContext* context, ::routeguide::RouteSummary* response, ::grpc::CompletionQueue* cq, void* tag) {
      return std::unique_ptr< ::grpc::ClientAsyncWriter< ::routeguide::Point>>(AsyncRecordRouteRaw(context, response, cq, tag));
    }
    std::unique_ptr< ::grpc::ClientReaderWriter< ::routeguide::RouteNote, ::routeguide::RouteNote>> RouteChat(::grpc::ClientContext* context) {
      return std::unique_ptr< ::grpc::ClientReaderWriter< ::routeguide::RouteNote, ::routeguide::RouteNote>>(RouteChatRaw(context));
    }
    std::unique_ptr<  ::grpc::ClientAsyncReaderWriter< ::routeguide::RouteNote, ::routeguide::RouteNote>> AsyncRouteChat(::grpc::ClientContext* context, ::grpc::CompletionQueue* cq, void* tag) {
      return std::unique_ptr< ::grpc::ClientAsyncReaderWriter< ::routeguide::RouteNote, ::routeguide::RouteNote>>(AsyncRouteChatRaw(context, cq, tag));
    }

   private:
    std::shared_ptr< ::grpc::Channel> channel_;
    ::grpc::ClientAsyncResponseReader< ::routeguide::Feature>* AsyncGetFeatureRaw(::grpc::ClientContext* context, const ::routeguide::Point& request, ::grpc::CompletionQueue* cq) GRPC_OVERRIDE;
    ::grpc::ClientReader< ::routeguide::Feature>* ListFeaturesRaw(::grpc::ClientContext* context, const ::routeguide::Rectangle& request) GRPC_OVERRIDE;
    ::grpc::ClientAsyncReader< ::routeguide::Feature>* AsyncListFeaturesRaw(::grpc::ClientContext* context, const ::routeguide::Rectangle& request, ::grpc::CompletionQueue* cq, void* tag) GRPC_OVERRIDE;
    ::grpc::ClientWriter< ::routeguide::Point>* RecordRouteRaw(::grpc::ClientContext* context, ::routeguide::RouteSummary* response) GRPC_OVERRIDE;
    ::grpc::ClientAsyncWriter< ::routeguide::Point>* AsyncRecordRouteRaw(::grpc::ClientContext* context, ::routeguide::RouteSummary* response, ::grpc::CompletionQueue* cq, void* tag) GRPC_OVERRIDE;
    ::grpc::ClientReaderWriter< ::routeguide::RouteNote, ::routeguide::RouteNote>* RouteChatRaw(::grpc::ClientContext* context) GRPC_OVERRIDE;
    ::grpc::ClientAsyncReaderWriter< ::routeguide::RouteNote, ::routeguide::RouteNote>* AsyncRouteChatRaw(::grpc::ClientContext* context, ::grpc::CompletionQueue* cq, void* tag) GRPC_OVERRIDE;
    const ::grpc::RpcMethod rpcmethod_GetFeature_;
    const ::grpc::RpcMethod rpcmethod_ListFeatures_;
    const ::grpc::RpcMethod rpcmethod_RecordRoute_;
    const ::grpc::RpcMethod rpcmethod_RouteChat_;
  };
  static std::unique_ptr<Stub> NewStub(const std::shared_ptr< ::grpc::Channel>& channel, const ::grpc::StubOptions& options = ::grpc::StubOptions());

  class Service : public ::grpc::SynchronousService {
   public:
    Service() : service_(nullptr) {}
    virtual ~Service();
    virtual ::grpc::Status GetFeature(::grpc::ServerContext* context, const ::routeguide::Point* request, ::routeguide::Feature* response);
    virtual ::grpc::Status ListFeatures(::grpc::ServerContext* context, const ::routeguide::Rectangle* request, ::grpc::ServerWriter< ::routeguide::Feature>* writer);
    virtual ::grpc::Status RecordRoute(::grpc::ServerContext* context, ::grpc::ServerReader< ::routeguide::Point>* reader, ::routeguide::RouteSummary* response);
    virtual ::grpc::Status RouteChat(::grpc::ServerContext* context, ::grpc::ServerReaderWriter< ::routeguide::RouteNote, ::routeguide::RouteNote>* stream);
    ::grpc::RpcService* service() GRPC_OVERRIDE GRPC_FINAL;
   private:
    ::grpc::RpcService* service_;
  };
  class AsyncService GRPC_FINAL : public ::grpc::AsynchronousService {
   public:
    explicit AsyncService();
    ~AsyncService() {};
    void RequestGetFeature(::grpc::ServerContext* context, ::routeguide::Point* request, ::grpc::ServerAsyncResponseWriter< ::routeguide::Feature>* response, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag);
    void RequestListFeatures(::grpc::ServerContext* context, ::routeguide::Rectangle* request, ::grpc::ServerAsyncWriter< ::routeguide::Feature>* writer, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag);
    void RequestRecordRoute(::grpc::ServerContext* context, ::grpc::ServerAsyncReader< ::routeguide::RouteSummary, ::routeguide::Point>* reader, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag);
    void RequestRouteChat(::grpc::ServerContext* context, ::grpc::ServerAsyncReaderWriter< ::routeguide::RouteNote, ::routeguide::RouteNote>* stream, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag);
  };
};

}  // namespace routeguide


#endif  // GRPC_route_5fguide_2eproto__INCLUDED
