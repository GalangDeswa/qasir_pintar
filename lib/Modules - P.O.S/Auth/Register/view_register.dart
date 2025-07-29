import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';

import 'package:flutter/material.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import 'controller_register.dart';

class Register extends GetView<RegisterController> {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Daftar',
        NeedBottom: false,
      ),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: SingleChildScrollView(
          child: Form(
            key: controller.registerKey(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daftar akun',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: AppPading.customBottomPadding(),
                  child: Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Sudah punya akun?'),
                            TextSpan(
                                text: ' Masuk',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primary),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed('/loginform');
                                  }),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                        height: 0.7,
                        margin: EdgeInsets.only(left: 10),
                        color: Colors.black,
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Informasi User'),
                          ],
                        ),
                      ),
                      Text("1/2"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColor.primary),
                      )),
                      Expanded(
                          child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey,
                        ),
                      ))
                    ],
                  ),
                ),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      controller: controller.nama.value,
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama harus diisi';
                        }
                        return null;
                      },
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      controller: controller.email.value,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email harus diisi';
                        } else if (value.isEmail == false) {
                          return 'Periksa format email';
                        }
                        return null;
                      },
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      controller: controller.telepon.value,
                      decoration: InputDecoration(
                        labelText: 'Nomor telepon',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nomor telepon harus diisi';
                        }
                        return null;
                      },
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      controller: controller.kodeRef.value,
                      decoration: InputDecoration(
                        labelText: 'Kode referal (optional)',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      //keyboardType: TextInputType.emailAddress,
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      obscureText: controller.showpass.value,
                      controller: controller.password.value,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        suffixIcon: IconButton(
                          icon: controller.showpass == false
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          onPressed: () {
                            controller.showpass.value =
                                !controller.showpass.value;
                            print(controller.showpass.value);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password harus diisi';
                        }
                        return null;
                      },
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      obscureText: controller.showkon.value,
                      controller: controller.konpass.value,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: controller.showkon == false
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          onPressed: () {
                            controller.showkon.value =
                                !controller.showkon.value;
                            print(controller.showkon.value);
                          },
                        ),
                        labelText: 'Konfirmasi password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty ||
                            value != controller.password.value.text) {
                          return 'Password tidak sesuai';
                        }
                        return null;
                      },
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      obscureText: controller.showpin.value,
                      controller: controller.pin.value,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'PIN Admin',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        suffixIcon: IconButton(
                          icon: controller.showpin == false
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          onPressed: () {
                            controller.showpin.value =
                                !controller.showpin.value;
                            print(controller.showpin.value);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'PIN harus diisi';
                        } else if (value.length < 6) {
                          return 'PIN harus 6 digit';
                        } else if (value.length > 6) {
                          return 'PIN tidak boleh lebih dari 6 digit';
                        }
                        return null; // Valid PIN
                      },
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      obscureText: controller.showkonpin.value,
                      controller: controller.konpin.value,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: controller.showkonpin == false
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          onPressed: () {
                            controller.showkonpin.value =
                                !controller.showkonpin.value;
                            print(controller.showkonpin.value);
                          },
                        ),
                        labelText: 'Konfirmasi PIN',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty ||
                            value != controller.pin.value.text) {
                          return 'PIN tidak sesuai';
                        }
                        return null;
                      },
                    ),
                  );
                }),
                Obx(() {
                  return Padding(
                    padding: AppPading.customBottomPadding(),
                    child: TextFormField(
                      controller: controller.alamat.value,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Alamat harus diisi';
                        }
                        return null;
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
                        if (value == null) {
                          return 'Pilih provinsi';
                        }
                        return null;
                      },
                      isExpanded: true,
                      dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white)),
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
                        if (value == null) {
                          return 'Pilih Kabupaten';
                        }
                        return null;
                      },
                      isExpanded: true,
                      dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white)),
                      hint: Text('Pilih Kabupaten', style: AppFont.regular()),
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
                        if (value == null) {
                          return 'Pilih Kecamatan';
                        }
                        return null;
                      },
                      isExpanded: true,
                      dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white)),
                      hint: Text('Pilih Kecamatan', style: AppFont.regular()),
                      value: controller.districtvalue,
                      items: controller.districtList.map((x) {
                        return DropdownMenuItem(
                          child: Text(x.name!),
                          value: x.id,
                        );
                      }).toList(),
                      onChanged: (val) {
                        controller.districtvalue = val;
                        print(controller.districtvalue);
                      },
                    ),
                  );
                }),
                button_solid_custom(
                    onPressed: () {
                      if (controller.registerKey.value.currentState!
                          .validate()) {
                        controller.addusertemp();
                      }
                      //Get.toNamed('/setuptoko');
                      // Get.toNamed('/loginform');
                    },
                    child: Text(
                      'Selanjutnya',
                      style: AppFont.regular_white_bold(),
                    ),
                    width: context.res_width)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
