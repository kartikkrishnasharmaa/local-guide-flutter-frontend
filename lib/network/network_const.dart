class EndPoints {
  // Maps Library
  static const GET_PLACES = "map/get_places";

  // User APIs
  static const LOGIN = 'user/login';
  static const REGISTER = 'user/register';
  static const FORGET_PASSWORD = 'user/forget_password';
  static const UPDATE_USER = 'user/update_profile';
  static const GET_PROFILE = 'user/get_profile';
  static const GET_USERS = 'user/get_user_list';
  static const DELETE_USER = 'user/delete';

  static const CHECK_PHONE_EXISTS = 'user/check_phone_exist/phone=';

  // Images APIs
  static const ALL_IMAGES_BY_ID = '/images/get_by_id';
  static const ADD_IMAGE = '/images/add';
  static const DELETE_IMAGE = '/images/delete';

  // Home APIs
  static const HOME_DETAILS = 'main/home_details';
  static const ADMIN_DASHBOARD = 'main/admin_dashboard';

  // Photographers
  static const GET_PHOTOGRAPHERS_BY_PLACE_ID = "photographers/get_by_place";
  static const GET_PHOTOGRAPHERS = "photographers/get_all";
  static const GET_PHOTOGRAPHER_DETAILS = "photographers/details";
  static const RESPOND_PHOTOGRAPHER = "photographers/respond_on_request";
  static const CHANGE_PHOTOGRAPHER_ACTIVE_STATUS = "photographers/change_active_status";

  // Guiders
  static const GET_GUIDERS_BY_PLACE_ID = "guider/get_by_place";
  static const GET_GUIDERS = "guider/get_all";
  static const GET_GUIDER_DETAILS = "guider/details";
  static const RESPOND_GUIDER = "guider/respond_on_request";
  static const CHANGE_GUIDER_ACTIVE_STATUS = "/guider/change_active_status";

  // Review API
  static const ALL_REVIEWS_BY_ID = '/review/get_all';
  static const ADD_REVIEW = '/review/add';

  // Services APIs
  static const GET_SERVICES = 'service/get';
  static const DELETE_SERVICES = 'service/delete';
  static const SAVE_SERVICES = 'service/create';
  static const UPDATE_SERVICES = 'service/update';

  // Places APIs
  static const GET_PLACES_LIST = 'places/get';
  static const GET_PLACES_BY_IDS_LIST = 'places/get_by_ids';
  static const ADD_PLACE = 'places/add';
  static const UPDATE_PLACE = 'places/edit';
  static const DELETE_PLACE = 'places/delete';


  // Appointments
  static const CREATE_APPOINTMENT = 'appointment/create';
  static const GET_APPOINTMENT = 'appointment/get_all';
  static const RESPOND_APPOINTMENT = 'appointment/respond';
  static const GET_APPOINTMENT_BY_TRANSACTION_ID = "/appointment/get_by_transaction_id";

  // Transaction
  static const CREATE_TRANSACTION = 'transaction/create';
  static const UPDATE_TRANSACTION = 'transaction/update';
  static const TRANSACTION_LIST = 'transaction/get';

  // Commons
  static const REQUEST_FOR_PHOTOGRAPHER = "photographers/request";
  static const REQUEST_FOR_GUIDER = "guider/request";
  static const UPDATE_PHOTOGRAPHER = "photographers/update";
  static const UPDATE_GUIDER = "guider/update";

  // Withdrawal
  static const MAKE_WITHDRAWAL = 'withdrawal/create';
  static const GET_WITHDRAWAL = 'withdrawal/get';
  static const RESPOND_WITHDRAWAL = 'withdrawal/respond';

  // Settings
  static const GET_SETTINGS = 'settings/get';
  static const UPDATE_SETTINGS = 'settings/update';

  // Downloads
  static const DOWNLOAD_USERS = "download/users";
  static const DOWNLOAD_PHOTOGRAPHERS = "download/photographers";
  static const DOWNLOAD_GUIDERS = "download/guiders";
  static const DOWNLOAD_PLACES = "download/places";
  static const DOWNLOAD_TRANSACTIONS = "download/transactions";
  static const DOWNLOAD_WITHDRAWALS = "download/withdrawals";

  // Notifications
  static const GET_NOTIFICATION = "notification/get_by_id";
  static const DELETE_NOTIFICATION = "notification/delete";
  static const NOTIFICATION_MARK_AS_READ = "notification/mark_as_read";
  static const CREATE_NOTIFICATION = "notification/create";


}

class NetworkConst {
  static const String AUTH_TOKEN = 'auth_token';
  static const String PHONE_NUMBER = 'phone_number';
  static const String PROFILE_IMAGE = 'profile_image';
  static const String COVER_IMAGE = 'cover_image';
  static const String FIRST_NAME = 'first_name';
  static const String USER_NAME = 'username';
  static const String USER_ID = 'user_id';
  static const String BIRTH_DATE = 'birth_date';
  static const String WEIGHT = 'weight';
  static const String HEIGHT = 'height';
  static const String GENDER = 'gender';
  static const String BLOOD_GROUP = 'blood_group';
  static const String LAST_NAME = 'last_name';
  static const String EMAIL = 'email';
  static const String SOCIAL_ID = 'social_id';
  static const String SOCIAL_TYPE = 'social_type';
  static const String OTP = 'otp';
  static const String SENDER_ID = 'sender_id';
  static const String RECEIVER_ID = 'receiver_id';
  static const String DATA = 'data';
}
