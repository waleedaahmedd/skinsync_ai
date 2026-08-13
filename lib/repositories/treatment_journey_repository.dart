import '../models/requests/create_group_request.dart';
import '../models/requests/tj_options_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/groups_list_response.dart';
import '../models/responses/tj_options_list_response.dart';

abstract class TreatmentJourneyRepository {
  Future<GroupsListResponse> getGroups();
  Future<BaseResponseModel> createGroup(CreateGroupRequest request);
  Future<TJOptionsListResponse> getOptions(int groupId);
  Future<BaseResponseModel> createTjOptions(TjOptionsRequest request);
}
