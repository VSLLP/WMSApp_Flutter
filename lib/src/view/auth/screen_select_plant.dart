import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/home/screen_home.dart';

class ScreenSelectPlant extends StatefulWidget {
  const ScreenSelectPlant({super.key});

  @override
  State<ScreenSelectPlant> createState() => _ScreenSelectPlantState();
}

class _ScreenSelectPlantState extends State<ScreenSelectPlant> {
  final _formInit = GlobalKey<FormState>();

  var txtPlant = TextEditingController();
  var txtEmpid = TextEditingController();

  List<String> plants = [];

  String Company = "";
  String UserId = "";

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
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: 30,
                              height: 30,
                              child: Center(
                                child: Icon(
                                  Icons.keyboard_backspace_rounded,
                                  size: 28,
                                  color: AppColors.colorBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Welcome',
                            style: TextStyles.getBold(
                              22,
                              color: AppColors.colorWhite,
                            ),
                          ),
                        )
                      ],
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
                              controller: txtPlant,
                              decoration: InputDecoration(
                                labelText: "Please select",
                                labelStyle: TextStyles.getBold(
                                  16,
                                  color: AppColors.colorGray600,
                                ),
                                contentPadding: const EdgeInsets.all(4),
                                counterText: "",
                              ),
                              onTap: () {
                                choseOption();
                              },
                              keyboardType: TextInputType.name,
                              autofocus: false,
                              readOnly: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please select plant.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            TextFormField(
                              controller: txtEmpid,
                              decoration: InputDecoration(
                                labelText: "EmpId",
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
                                  return "Please enter empid.";
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
                                            'Login',
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

  loadData() async {
    var profileJson = await sharedPref.getJson("profile");
    if (profileJson == null || profileJson.trim().isEmpty) {
      if (!mounted) return;
      Navigator.of(context).pop();
    }
    var payload = json.decode(profileJson);
    Company = payload['Calculated_Company'];
    UserId = payload['Calculated_UserID'];
    txtEmpid.text = payload['Calculated_EmployeeID'];
    plants.clear();
    plants = payload['Calculated_PlantList'].toString().split("~");
    plants.sort();
    setState(() {
      isLoading = false;
    });
  }

  submitLogin() async {
    try {
      if (_formInit.currentState!.validate()) {
        var body = {
          "Company": Company,
          "UserId": UserId,
          "SelectedPlant": txtPlant.text,
        };
        setState(() {
          isLoading = true;
        });
        await authServices.plantPatchAsync(body);
        await sharedPref.setString("userPlant", txtPlant.text);
        if (!mounted) return;
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ScreenHome()),
        );
        txtPlant.text = '';
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

  choseOption() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Plant",
                  style: TextStyles.getBold(18),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: AppColors.colorGray100,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SizedBox(
                    child: ListView.builder(
                      itemCount: plants.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            txtPlant.text = plants[index];
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Container(
                            color: Colors.transparent,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plants[index],
                                  style: TextStyles.getRegularScund(
                                    16,
                                    color: AppColors.colorGray600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: AppColors.colorGray100,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        child: Text(
                          "Cancel",
                          style: TextStyles.getBold(14),
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
