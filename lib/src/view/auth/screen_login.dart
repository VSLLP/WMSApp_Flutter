import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/auth/screen_select_plant.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _formInit = GlobalKey<FormState>();

  var txtUrl = TextEditingController();
  var txtCompany = TextEditingController();
  var txtUsername = TextEditingController();
  var txtPassword = TextEditingController();

  bool isLoading = true;
  bool isSubmit = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenNetwork(
        child: Scaffold(
          backgroundColor: AppColors.colorWhite,
          body: ScreenBackground(
            isLoading: isLoading,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 22,
                  ),
                  Text(
                    'Welcome',
                    style: TextStyles.getBold(
                      22,
                      color: AppColors.colorWhite,
                    ),
                  ),
                  Expanded(
                    child: Form(
                      key: _formInit,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: txtUrl,
                              decoration: InputDecoration(
                                labelText: "Url",
                                labelStyle: TextStyles.getBold(
                                  16,
                                  color: AppColors.colorGray600,
                                ),
                                contentPadding: const EdgeInsets.all(4),
                                counterText: "",
                              ),
                              keyboardType: TextInputType.name,
                              autofocus: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter url.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              controller: txtCompany,
                              decoration: InputDecoration(
                                labelText: "Company",
                                labelStyle: TextStyles.getBold(
                                  16,
                                  color: AppColors.colorGray600,
                                ),
                                contentPadding: const EdgeInsets.all(4),
                                counterText: "",
                              ),
                              keyboardType: TextInputType.name,
                              autofocus: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter company.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              controller: txtUsername,
                              decoration: InputDecoration(
                                labelText: "Username",
                                labelStyle: TextStyles.getBold(
                                  16,
                                  color: AppColors.colorGray600,
                                ),
                                contentPadding: const EdgeInsets.all(4),
                                counterText: "",
                              ),
                              keyboardType: TextInputType.name,
                              autofocus: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter username.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              controller: txtPassword,
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyles.getBold(
                                  16,
                                  color: AppColors.colorGray600,
                                ),
                                contentPadding: const EdgeInsets.all(4),
                                counterText: "",
                              ),
                              keyboardType: TextInputType.name,
                              obscureText: true,
                              autofocus: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter password.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!isSubmit) {
                                  submitLogin();
                                }
                              },
                              child: Container(
                                height: 38,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.colorWhite,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.colorTansprent40,
                                      blurRadius: 2,
                                      offset: const Offset(-2, -2),
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: isSubmit
                                      ? Lottie.asset(
                                          'assets/anim/anim-btnLoading.json',
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: Text(
                                            'Proceed',
                                            style: TextStyles.getBold(
                                              14,
                                              color: AppColors.colorPrimary,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 72,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setDefaultData() {
    // txtUrl.text = "https://epicor.ceasefire.asia/CFILPilot/api/v1";
    //txtUrl.text = "https://epicor.ceasefire.asia/E11INP/api/v1";
    txtUrl.text =
        //"https://epicor.ceasefire.asia/E11INLIVE/api/v1"; //commented and added by shraddha 19-sep-2025
        "https://epicor.ceasefire.asia/E11INP/api/v1";
    txtCompany.text = "CTEMP1";
    // txtUsername.text = "manager";
    // txtUsername.text = "vswmsdl09";
    //txtUsername.text = "vswmsuk90";
    // txtPassword.text = "2025@Tru";
    // txtPassword.text = "vswmsdl09";
    //txtPassword.text = "2025@Tru";
  }

  loadData() {
    setDefaultData();
    setState(() {
      isLoading = false;
    });
  }

  submitLogin() async {
    try {
      if (_formInit.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        var body = {
          "BaseUrl": txtUrl.text,
          "Company": txtCompany.text,
          "UserId": txtUsername.text,
          "Password": txtPassword.text,
          "SelectedPlant": "",
        };
        var response = await authServices.getEmployeeDetailAsync(
          body,
          txtUrl.text,
        );
        setState(() {
          isLoading = false;
        });
        if (response == null || response['value'] == null) {
          showError("", "Invalid response");
        } else {
          var profileDetails = response['value'][0];
          print("${profileDetails['Calculated_UserID']}");

          if ((profileDetails['Calculated_UserID'] == null ||
                  profileDetails['Calculated_UserID'].trim().isEmpty) ||
              (profileDetails['Calculated_Company'] == null ||
                  profileDetails['Calculated_Company'].trim().isEmpty) ||
              (profileDetails['Calculated_CurrentPlant'] == null ||
                  profileDetails['Calculated_CurrentPlant'].trim().isEmpty)) {
            showError(
                "", "UserId / Company / Plant list are empty in response.");
          } else {
            await sharedPref.setBool("userStatus", true);
            await sharedPref.setString("userName", txtUsername.text);
            await sharedPref.setString("userPass", txtPassword.text);
            await sharedPref.setString("userCompnay", txtCompany.text);
            await sharedPref.setString("userUrl", txtUrl.text);
            await sharedPref.setJson("profile", json.encode(profileDetails));
            if (!mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const ScreenSelectPlant()),
            );
          }
        }
        txtUsername.text = '';
        txtPassword.text = '';
      }
    } catch (ex) {
      showError('', ex.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  showError(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.getRegularScund(20),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyles.getRegularScund(14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: Container()),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        child: Text(
                          'OK',
                          style: TextStyles.getBold(
                            14,
                            color: AppColors.colorPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
