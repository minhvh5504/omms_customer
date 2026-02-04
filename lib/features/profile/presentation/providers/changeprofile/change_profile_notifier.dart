// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';

// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:dio/dio.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

// import '../../../../../core/config/routing/app_routes.dart';
// import '../../../../../core/domain/entities/app_etities.dart';
// import '../../../../../core/presentation/providers/app_provider.dart';
// import '../../../../../core/presentation/theme/app_colors.dart';
// import '../../../../../core/utils/validation.dart';
// import '../../../domain/usecases/update_avatar.dart';
// import '../../../domain/usecases/update_user.dart';
// import '../../widgets/gender_picker_drop_down.dart';

// /// STATE
// class ChangeProfileState {
//   final User? user;
//   final bool isLoading;
//   final bool hasChanges;
//   final String? errorMessage;
//   final bool hasNameError;
//   final TextEditingController phoneController;
//   final TextEditingController birthdayController;
//   final TextEditingController fullNameController;
//   final TextEditingController emailController;
//   final String? gender;
//   final bool isGenderSelecting;
//   final String specializationText;
//   final String? avatarImage;

//   const ChangeProfileState({
//     this.user,
//     this.isLoading = false,
//     this.hasChanges = false,
//     this.errorMessage,
//     this.hasNameError = false,
//     required this.fullNameController,
//     required this.phoneController,
//     required this.birthdayController,
//     required this.emailController,
//     this.gender,
//     this.isGenderSelecting = false,
//     this.specializationText = 'Specializations',
//     this.avatarImage,
//   });

//   ChangeProfileState copyWith({
//     User? user,
//     bool? isLoading,
//     bool? hasChanges,
//     String? errorMessage,
//     bool? hasNameError,
//     TextEditingController? fullNameController,
//     TextEditingController? phoneController,
//     TextEditingController? birthdayController,
//     TextEditingController? emailController,
//     String? gender,
//     bool? isGenderSelecting,
//     String? specializationText,
//     String? avatarImage,
//   }) {
//     return ChangeProfileState(
//       user: user ?? this.user,
//       isLoading: isLoading ?? this.isLoading,
//       hasChanges: hasChanges ?? this.hasChanges,
//       errorMessage: errorMessage,
//       hasNameError: hasNameError ?? this.hasNameError,
//       fullNameController: fullNameController ?? this.fullNameController,
//       phoneController: phoneController ?? this.phoneController,
//       birthdayController: birthdayController ?? this.birthdayController,
//       emailController: emailController ?? this.emailController,
//       gender: gender ?? this.gender,
//       isGenderSelecting: isGenderSelecting ?? this.isGenderSelecting,
//       specializationText: specializationText ?? this.specializationText,
//       avatarImage: avatarImage ?? this.avatarImage,
//     );
//   }
// }

// /// NOTIFIER
// class ChangeProfileNotifier extends StateNotifier<ChangeProfileState> {
//   final UpdateUser _updateUserUseCase;
//   final UpdateAvatar _updateAvatarUseCase;
//   final Ref ref;
//   final ImagePicker _picker = ImagePicker();

//   ChangeProfileNotifier(
//     this._updateUserUseCase,
//     this._updateAvatarUseCase,
//     this.ref,
//   ) : super(
//         ChangeProfileState(
//           fullNameController: TextEditingController(),
//           phoneController: TextEditingController(),
//           birthdayController: TextEditingController(),
//           emailController: TextEditingController(),
//         ),
//       ) {
//     _initUserFromProfile();
//     _initListeners();
//     ref.listen(profileNotifierProvider, (prev, next) {
//       if (next.user != null) {
//         _syncUser(next.user!);
//       }
//     });
//   }

//   /// Load current
//   void _initUserFromProfile() {
//     final profileState = ref.read(profileNotifierProvider);
//     final user = profileState.user;

//     if (user != null) {
//       state.fullNameController.text = user.fullName;
//       state.phoneController.text = user.phone;
//       state.emailController.text = user.email ?? '';

//       if (user.birthDay != null) {
//         state.birthdayController.text =
//             '${user.birthDay!.day}/${user.birthDay!.month}/${user.birthDay!.year}';
//       }

//       state = state.copyWith(user: user, gender: user.gender);
//     }
//   }

//   /// Listen for changes
//   void _initListeners() {
//     state.fullNameController.addListener(_checkChanges);
//     // state.phoneController.addListener(_checkChanges);
//     state.birthdayController.addListener(_checkChanges);
//     // state.emailController.addListener(_checkChanges);
//   }

//   /// Sync user
//   void _syncUser(User newUser) {
//     state.fullNameController.text = newUser.fullName;
//     state.phoneController.text = newUser.phone;
//     state.emailController.text = newUser.email ?? '';

//     state.birthdayController.text = newUser.birthDay != null
//         ? '${newUser.birthDay!.day}/${newUser.birthDay!.month}/${newUser.birthDay!.year}'
//         : '';

//     state = state.copyWith(
//       user: newUser,
//       avatarImage: newUser.picture,
//       hasChanges: false,
//     );
//   }

//   /// Check if fields changed
//   void _checkChanges() {
//     final user = state.user;
//     if (user == null) return;

//     final currName = state.fullNameController.text;

//     final isNameValid = Validation.isValidUsername(currName);

//     state = state.copyWith(hasNameError: currName.isNotEmpty && !isNameValid);

//     final originalName = user.fullName;

//     final originalBirthday = user.birthDay != null
//         ? '${user.birthDay!.day}/${user.birthDay!.month}/${user.birthDay!.year}'
//         : '';

//     final originalAvatar = user.picture;
//     final originalGender = user.gender;

//     final currBirthday = state.birthdayController.text.trim();
//     final currAvatar = state.avatarImage;
//     final currGender = state.gender;

//     final bool changed =
//         isNameValid &&
//         (currName.trim() != originalName ||
//             currBirthday != originalBirthday ||
//             currGender != originalGender ||
//             (currAvatar != null && currAvatar != originalAvatar));

//     if (changed != state.hasChanges) {
//       state = state.copyWith(hasChanges: changed);
//     }
//   }

//   /// Pick birthday
//   Future<void> pickBirthday(BuildContext context) async {
//     DateTime initialDate;

//     if (state.user?.birthDay != null) {
//       initialDate = state.user!.birthDay!;
//     } else if (state.birthdayController.text.isNotEmpty) {
//       final parts = state.birthdayController.text.split('/');
//       if (parts.length == 3) {
//         initialDate = DateTime(
//           int.parse(parts[2]),
//           int.parse(parts[1]),
//           int.parse(parts[0]),
//         );
//       } else {
//         initialDate = DateTime(2000, 1, 1);
//       }
//     } else {
//       initialDate = DateTime(2000, 1, 1);
//     }

//     final picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );

//     if (picked != null) {
//       state.birthdayController.text =
//           '${picked.day}/${picked.month}/${picked.year}';
//       _checkChanges();
//     }
//   }

//   /// Handle Back
//   void onBack(BuildContext context) => context.go(AppRoutes.profile);

//   /// Handle phone tap
//   void handlePhoneTap(BuildContext context) {
//     context.go(AppRoutes.changephone);
//   }

//   /// Handle email tap
//   void handleEmailTap(BuildContext context) {
//     context.go(AppRoutes.changeemail);
//   }

//   /// Save updated profile info
//   Future<void> onSave(BuildContext context) async {
//     try {
//       state = state.copyWith(isLoading: true);

//       DateTime? parsedDate;
//       final parts = state.birthdayController.text.trim().split('/');
//       if (parts.length == 3) {
//         parsedDate = DateTime(
//           int.parse(parts[2]),
//           int.parse(parts[1]),
//           int.parse(parts[0]),
//         );
//       }

//       await _updateUserUseCase(
//         fullName: state.fullNameController.text,
//         birthDay: parsedDate,
//         gender: state.gender,
//       );

//       await ref.read(profileNotifierProvider.notifier).fetchData(context);
//       final newUser = ref.read(profileNotifierProvider).user;

//       state = state.copyWith(
//         user: newUser,
//         hasChanges: false,
//         isLoading: false,
//       );

//       context.go(AppRoutes.profile);
//     } catch (e) {
//       _handleFailure(context, e);
//     }
//   }

//   /// Show picker
//   void showPicker(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('Choose from Gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 pickFromGallery(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text('Take Photo'),
//               onTap: () {
//                 Navigator.pop(context);
//                 onTapPhoto(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Handle open gender popup
//   Future<void> openGenderPopup(BuildContext context) async {
//     state = state.copyWith(isGenderSelecting: true);

//     final renderBox = context.findRenderObject() as RenderBox;
//     final size = renderBox.size;
//     final offset = renderBox.localToGlobal(Offset.zero);
//     await showGeneralDialog(
//       context: context,
//       barrierLabel: '',
//       barrierColor: Colors.black12,
//       barrierDismissible: true,
//       pageBuilder: (_, __, ___) {
//         return Stack(
//           children: [
//             Positioned.fill(
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(color: Colors.transparent),
//               ),
//             ),
//             Positioned(
//               left: offset.dx,
//               top: offset.dy + size.height + 4,
//               width: size.width,
//               child: Material(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.white,
//                 elevation: 6,
//                 child: GenderPickerDropdown(
//                   onSelect: (value) {
//                     setGender(value);
//                   },
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );

//     state = state.copyWith(isGenderSelecting: false);
//   }

//   /// Handle set gender
//   void setGender(String? value) {
//     state = state.copyWith(gender: value);
//     _checkChanges();
//   }

//   /// Handle format gender
//   String formatGender(String? g) {
//     if (g == null || g.trim().isEmpty) {
//       return 'change_profile.select_gender'.tr();
//     }

//     switch (g.toLowerCase()) {
//       case 'male':
//         return 'change_profile.male'.tr();
//       case 'female':
//         return 'change_profile.female'.tr();
//       case 'other':
//         return 'change_profile.other'.tr();
//       default:
//         return g;
//     }
//   }

//   /// Take photo
//   void onTapPhoto(BuildContext context) {
//     context.go(AppRoutes.takecamera);
//   }

//   /// Add image from camera
//   void addImageFromCamera(String path, BuildContext context) {
//     addImage(path, context);
//   }

//   /// Pick from gallery
//   Future<void> pickFromGallery(BuildContext context) async {
//     if (!await _checkPermission()) return;

//     try {
//       final XFile? xfile = await _picker.pickImage(source: ImageSource.gallery);

//       if (xfile == null) return;

//       addImage(xfile.path, context);
//     } catch (e) {
//       _handleFailure(context, e);
//     }
//   }

//   /// Add image
//   void addImage(String path, BuildContext context) {
//     state = state.copyWith(avatarImage: path, hasChanges: true);
//     uploadAvatar(path, context);
//   }

//   /// Upload avatar
//   Future<void> uploadAvatar(String path, BuildContext context) async {
//     try {
//       state = state.copyWith(isLoading: true);

//       final file = XFile(path);

//       await _updateAvatarUseCase(file);

//       state = state.copyWith(avatarImage: path);

//       await ref.read(profileNotifierProvider.notifier).fetchData(context);

//       final newUser = ref.read(profileNotifierProvider).user;
//       state = state.copyWith(user: newUser, avatarImage: newUser?.picture);

//       state = state.copyWith(isLoading: false);
//     } catch (e) {
//       _handleFailure(context, e);
//     }
//   }

//   ///  Check permission
//   Future<bool> _checkPermission() async {
//     final camera = await Permission.camera.request();
//     final storage = await Permission.storage.request();

//     if (Platform.isAndroid) {
//       final androidInfo = await DeviceInfoPlugin().androidInfo;
//       if (androidInfo.version.sdkInt >= 33) {
//         final photos = await Permission.photos.request();
//         return camera.isGranted && photos.isGranted;
//       }
//     }

//     return storage.isGranted && camera.isGranted;
//   }

//   /// Handle failure
//   void _handleFailure(BuildContext context, Object error) {
//     String errorMessage = 'Unknown error';

//     if (error is DioException) {
//       final data = error.response?.data;

//       if (data is Map<String, dynamic>) {
//         errorMessage = data['message']?.toString() ?? errorMessage;
//       } else {
//         errorMessage = error.message ?? errorMessage;
//       }
//     } else {
//       errorMessage = error.toString();
//     }

//     final message = errorMessage;

//     state = state.copyWith(isLoading: false, errorMessage: message);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: AppColors.typoError,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     state.fullNameController.dispose();
//     // state.phoneController.dispose();
//     state.birthdayController.dispose();
//     // state.emailController.dispose();
//     super.dispose();
//   }
// }
