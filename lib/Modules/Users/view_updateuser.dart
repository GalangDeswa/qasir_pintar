import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Modules/Users/controller_updateuser.dart';
import 'package:qasir_pintar/Modules/Users/controller_user.dart';

import '../../Config/config.dart';
import '../../Widget/widget.dart';

class UpdateUser extends GetView<UpdateUserController> {
  const UpdateUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(title: 'Update user', NeedBottom: false),
      body: SingleChildScrollView(
        padding: AppPading.defaultBodyPadding(),
        child: Form(
          key: controller.registerLokasiKey(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Obx(() {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.primary,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: controller.pikedImagePath.value != ''
                              ? ClipOval(
                                  child: Image.file(
                                    File(controller.pickedImageFile!.path),
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : controller.logo.value != null &&
                                      controller.logo.value != '-'
                                  ? CircleAvatar(
                                      backgroundImage: MemoryImage(
                                        base64Decode(controller.logo.value),
                                      ),
                                      backgroundColor: Colors.white,
                                      radius: 80,
                                    )
                                  : Icon(
                                      FontAwesomeIcons.image,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                              AndroidDeviceInfo androidInfo =
                                  await deviceInfo.androidInfo;
                              if (androidInfo.version.sdkInt >= 33) {
                                var status = await Permission.camera.status;
                                if (!status.isGranted) {
                                  await Permission.camera.request();
                                }
                              } else {
                                var status = await Permission.camera.status;
                                if (!status.isGranted) {
                                  await Permission.camera.request();
                                }
                              }
                              controller.pilihsourcefoto();
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.secondary,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                controller.pikedImagePath.value == ''
                                    ? Icons.add
                                    : FontAwesomeIcons.pencil,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        if (controller.pikedImagePath.value != '' ||
                            controller.logo.value != '-' ||
                            controller.logo.value != null)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () {
                                // Call a method in the controller to delete the image
                                controller.deleteImage();
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      Colors.red, // Red color for delete button
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                      ],
                    );
                  }),
                ),
              ),

              // Form Fields
              _buildFormField(
                controller: controller.nama.value,
                label: 'Nama Usaha',
                validator: (value) {
                  if (value!.isEmpty) return 'Nama usaha harus diisi';
                  return null;
                },
              ),
              _buildFormField(
                controller: controller.email.value,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return 'Email harus diisi';
                  if (!value.isEmail) return 'Periksa format email';
                  return null;
                },
              ),
              _buildFormField(
                controller: controller.telepon.value,
                label: 'Nomor Telepon',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) return 'Nomor telepon harus diisi';
                  return null;
                },
              ),
              _buildFormField(
                controller: controller.alamat.value,
                label: 'Alamat',
                validator: (value) {
                  if (value!.isEmpty) return 'Alamat harus diisi';
                  return null;
                },
              ),

              // Dropdowns for Province, Regency, and District (unchanged)
              Obx(() {
                return Padding(
                  padding: AppPading.customBottomPadding(),
                  child: DropdownButtonFormField2(
                    key: UniqueKey(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) return 'Pilih provinsi';
                      return null;
                    },
                    isExpanded: true,
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                    ),
                    hint: Text('Pilih provinsi', style: AppFont.regular()),
                    value: controller.provincevalue,
                    items: controller.provinceList.map((x) {
                      return DropdownMenuItem(
                        child: Text(x.name!),
                        value: x.id,
                      );
                    }).toList(),
                    onChanged: (val) {
                      controller.provincevalue = val;
                      controller.provinceId = val;

                      // Reset regency and district values
                      controller.regencyvalue = null;
                      controller.districtvalue = null;

                      // Clear the regency and district lists
                      controller.regencyList.clear();
                      controller.districtList.clear();

                      // Fetch new regency data
                      controller.getRegencyLocal(provinceId: val).then((_) {
                        // After fetching regency data, reset the regency dropdown
                        controller.regencyvalue = null;
                      });
                    },
                  ),
                );
              }),
              Obx(() {
                return Padding(
                  padding: AppPading.customBottomPadding(),
                  child: DropdownButtonFormField2(
                    key: UniqueKey(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) return 'Pilih kabupaten';
                      return null;
                    },
                    isExpanded: true,
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                    ),
                    hint: Text('Pilih kabupaten', style: AppFont.regular()),
                    value: controller.regencyvalue,
                    items: controller.regencyList.map((x) {
                      return DropdownMenuItem(
                        child: Text(x.name!),
                        value: x.id,
                      );
                    }).toList(),
                    onChanged: (val) {
                      controller.regencyvalue = val;
                      controller.regencyId = val;

                      // Reset district value
                      controller.districtvalue = null;

                      // Clear the district list
                      controller.districtList.clear();

                      // Fetch new district data
                      controller
                          .getDistrictLocal(
                        provinceId: controller.provinceId,
                        regencyId: val,
                      )
                          .then((_) {
                        // After fetching district data, reset the district dropdown
                        controller.districtvalue = null;
                      });
                    },
                  ),
                );
              }),
              Obx(() {
                return Padding(
                  padding: AppPading.customBottomPadding(),
                  child: DropdownButtonFormField2(
                    key: UniqueKey(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) return 'Pilih kecamatan';
                      return null;
                    },
                    isExpanded: true,
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                    ),
                    hint: Text('Pilih kecamatan', style: AppFont.regular()),
                    value: controller.districtvalue,
                    items: controller.districtList.map((x) {
                      return DropdownMenuItem(
                        child: Text(x.name!),
                        value: x.id,
                      );
                    }).toList(),
                    onChanged: (val) {
                      controller.districtvalue = val;
                    },
                  ),
                );
              }),

              // Update Button
              button_solid_custom(
                  onPressed: () {
                    if (controller.registerLokasiKey.value.currentState!
                        .validate()) {
                      controller.editUserLocal();
                    }
                  },
                  child: Text('Edit user'),
                  width: context.res_width)
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a form field
  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: AppPading.customBottomPadding(),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}
