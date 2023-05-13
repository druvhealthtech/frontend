import 'package:druvtech/screens/user_info_screen.dart';
import 'package:druvtech/utils/apis/api_service.dart';
import 'package:druvtech/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import '../res/custom_colors.dart';
import '../res/variables.dart';

class FormScreen extends StatefulWidget {
  // final String? token;

  const FormScreen({Key? key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

enum Gender { male, female }

enum BloodGroup { ap, an, bp, bn, op, on, abp, abn }

enum DiabetesType { one, two }

enum FitnessLevel { low, medium, high }

class _FormScreenState extends State<FormScreen> {
  int currentStep = 0;
  bool isCompleted = false;
  Gender? _gender = Gender.male;
  DiabetesType? _diabetesType = DiabetesType.one;
  FitnessLevel? _fitnessLevel = FitnessLevel.low;
  BloodGroup? _bloodGroup = BloodGroup.op;
  final double _age = 21;
  double _height = 120;
  double _weight = 60;
  bool tncAccepted = false;
  bool isAPICallProcess = true;

  final firstName = TextEditingController();
  final middleName = TextEditingController();
  final lastName = TextEditingController();
  final gender = TextEditingController();
  final dob = TextEditingController();
  final age = TextEditingController();
  final height = TextEditingController();
  final weight = TextEditingController();
  bool insulin = false;
  bool pills = false;
  final sugarBeforeMealLow = TextEditingController();
  final sugarBeforeMealHigh = TextEditingController();
  final sugarAfterMealLow = TextEditingController();
  final sugarAfterMealHigh = TextEditingController();

  // dob.text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        title: const AppBarTitle(),
      ),
      body:
          // isCompleted ? // form submitted widget :
          SingleChildScrollView(
        child: Theme(
          data: ThemeData(
            canvasColor: CustomColors.firebaseNavy,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.tealAccent.shade400,
                  background: Colors.grey.shade600,
                  secondary: Colors.tealAccent.shade400,
                ),
          ),
          child: Stepper(
            // type: StepperType.horizontal,
            steps: getSteps(),
            currentStep: currentStep,
            onStepContinue: () {
              final isLastStep = (currentStep == getSteps().length - 1);
              if (isLastStep) {
                setState(() => tncAccepted == true
                    ? isCompleted = true
                    : isCompleted = false);
                print(
                    '\n--------------------------------------------\n\tForm Completed!\n--------------------------------------------\n');
                print(
                    '\nFirst Name: ${firstName.text}\nMiddle Name: ${middleName.text}\nLast Name: ${lastName.text}\nGender: ${_gender.toString().split('.').last}\nDoB: ${dob.text}\nHeight(cm): $_height\nWeight(kg): $_weight\nBlood Group: ${_bloodGroup.toString().split('.').last}\nDiabetes Type: ${_diabetesType.toString().split('.').last}\nTherapy: Insuline=$insulin, Pills=$pills\nBlood Sugar Goal: SBML=${sugarBeforeMealLow.text}, SBMH=${sugarBeforeMealHigh.text}, SAML=${sugarAfterMealLow.text}, SAMH=${sugarAfterMealHigh.text}\nFitness Level: ${_fitnessLevel.toString().split('.').last}\nTnC Accepted: $tncAccepted\nToken: $token');

                // Add API call here !!
                setState(() {
                  isAPICallProcess = true;
                });
                APIService.patientDetails(
                  firstName.text.toString(),
                  middleName.text.toString(),
                  lastName.text.toString(),
                  _gender.toString().split('.').last,
                  dob.text.toString(),
                  _height,
                  _weight,
                  _bloodGroup.toString().split('.').last,
                  // widget.token.toString(),
                ).then(
                  (response) async {
                    setState(() {
                      isAPICallProcess = false;
                    });

                    if (response.token != null) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserInfoScreen()),
                      );
                    } else {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserInfoScreen()),
                      );
                    }
                  },
                );
              } else {
                setState(() => currentStep += 1);
              }
            },
            onStepCancel: currentStep == 0
                ? null
                : () => setState(() => currentStep -= 1),
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Container(
                margin: const EdgeInsets.only(top: 50),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: currentStep == getSteps().length - 1
                            ? const Text('Submit')
                            : const Text('Next'),
                        // child: const Text('Next'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (currentStep != 0)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Back'),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text("Name"),
          content: Column(
            children: <Widget>[
              TextFormField(
                controller: firstName,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                controller: middleName,
                decoration: const InputDecoration(labelText: 'Middle Name'),
              ),
              TextFormField(
                controller: lastName,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
            ],
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text("Gender"),
          content: Column(
            children: <Widget>[
              ListTile(
                title: const Text('Male'),
                leading: Radio<Gender>(
                  value: Gender.male,
                  groupValue: _gender,
                  onChanged: (Gender? value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Female'),
                leading: Radio<Gender>(
                  value: Gender.female,
                  groupValue: _gender,
                  onChanged: (Gender? value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text("Date of Birth"),
          content: TextField(
            controller: dob,
            decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today), labelText: "Enter Date"),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1920),
                //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                setState(() {
                  dob.text = formattedDate;
                });
              } else {}
            },
          ),
        ),
        Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: const Text("Height (cm)"),
          content: Slider(
            value: _height,
            max: 200,
            divisions: 200,
            label: _height.round().toString(),
            onChanged: (double value) {
              setState(() {
                _height = value;
              });
            },
          ),
        ),
        Step(
          state: currentStep > 4 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 4,
          title: const Text("Weight (kg)"),
          content: Slider(
            value: _weight,
            max: 300,
            divisions: 300,
            label: _weight.round().toString(),
            onChanged: (double value) {
              setState(() {
                _weight = value;
              });
            },
          ),
        ),
        Step(
          state: currentStep > 5 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 5,
          title: const Text("Blood Group"),
          content: Column(
            children: <Widget>[
              ListTile(
                title: const Text('A+'),
                leading: Radio<BloodGroup>(
                  value: BloodGroup.ap,
                  groupValue: _bloodGroup,
                  onChanged: (BloodGroup? value) {
                    setState(() {
                      _bloodGroup = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('A-'),
                leading: Radio<BloodGroup>(
                  value: BloodGroup.an,
                  groupValue: _bloodGroup,
                  onChanged: (BloodGroup? value) {
                    setState(() {
                      _bloodGroup = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('B+'),
                leading: Radio<BloodGroup>(
                  value: BloodGroup.bp,
                  groupValue: _bloodGroup,
                  onChanged: (BloodGroup? value) {
                    setState(() {
                      _bloodGroup = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('B-'),
                leading: Radio<BloodGroup>(
                  value: BloodGroup.bn,
                  groupValue: _bloodGroup,
                  onChanged: (BloodGroup? value) {
                    setState(() {
                      _bloodGroup = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('O+'),
                leading: Radio<BloodGroup>(
                  value: BloodGroup.op,
                  groupValue: _bloodGroup,
                  onChanged: (BloodGroup? value) {
                    setState(() {
                      _bloodGroup = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('O-'),
                leading: Radio<BloodGroup>(
                  value: BloodGroup.on,
                  groupValue: _bloodGroup,
                  onChanged: (BloodGroup? value) {
                    setState(() {
                      _bloodGroup = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('AB+'),
                leading: Radio<BloodGroup>(
                  value: BloodGroup.abp,
                  groupValue: _bloodGroup,
                  onChanged: (BloodGroup? value) {
                    setState(() {
                      _bloodGroup = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('AB-'),
                leading: Radio<BloodGroup>(
                  value: BloodGroup.abn,
                  groupValue: _bloodGroup,
                  onChanged: (BloodGroup? value) {
                    setState(() {
                      _bloodGroup = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Step(
          state: currentStep > 6 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 6,
          title: const Text("Diabetes Type"),
          content: Column(
            children: <Widget>[
              ListTile(
                title: const Text('Type 1'),
                leading: Radio<DiabetesType>(
                  value: DiabetesType.one,
                  groupValue: _diabetesType,
                  onChanged: (DiabetesType? value) {
                    setState(() {
                      _diabetesType = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Type 2'),
                leading: Radio<DiabetesType>(
                  value: DiabetesType.two,
                  groupValue: _diabetesType,
                  onChanged: (DiabetesType? value) {
                    setState(() {
                      _diabetesType = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Step(
          state: currentStep > 7 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 7,
          title: const Text("Therapy"),
          content: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  Checkbox(
                    value: insulin,
                    onChanged: (bool? value) {
                      setState(() {
                        insulin = value!;
                      });
                    },
                  ),
                  const Text(
                    'Insulin ',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  Checkbox(
                    value: pills,
                    onChanged: (bool? value) {
                      setState(() {
                        pills = value!;
                      });
                    },
                  ),
                  const Text(
                    'Pills ',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
        Step(
          state: currentStep > 8 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 8,
          title: const Text("Blood Sugar Goal"),
          // ADD important point: (Please consult your doctor before setting your goals)
          content: Column(
            children: <Widget>[
              const Text(
                  '** (Please consult your doctor before setting your goals)'),
              TextFormField(
                controller: sugarBeforeMealLow,
                decoration:
                    const InputDecoration(labelText: 'Sugar Before Meal Low'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              TextFormField(
                controller: sugarBeforeMealHigh,
                decoration:
                    const InputDecoration(labelText: 'Sugar Before Meal High'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              TextFormField(
                controller: sugarAfterMealLow,
                decoration:
                    const InputDecoration(labelText: 'Sugar After Meal Low'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              TextFormField(
                controller: sugarAfterMealHigh,
                decoration:
                    const InputDecoration(labelText: 'Sugar After Meal High'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ],
          ),
        ),
        Step(
          state: currentStep > 9 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 9,
          title: const Text("Fitness Level"),
          content: Column(
            children: <Widget>[
              ListTile(
                title: const Text(
                    'Low (I usually sit around all day and not do much physical activity)'),
                leading: Radio<FitnessLevel>(
                  value: FitnessLevel.low,
                  groupValue: _fitnessLevel,
                  onChanged: (FitnessLevel? value) {
                    setState(() {
                      _fitnessLevel = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text(
                    'Medium (I usually walk and workout 2-3 times a week)'),
                leading: Radio<FitnessLevel>(
                  value: FitnessLevel.medium,
                  groupValue: _fitnessLevel,
                  onChanged: (FitnessLevel? value) {
                    setState(() {
                      _fitnessLevel = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('High (I workout 5 days a week)'),
                leading: Radio<FitnessLevel>(
                  value: FitnessLevel.high,
                  groupValue: _fitnessLevel,
                  onChanged: (FitnessLevel? value) {
                    setState(() {
                      _fitnessLevel = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Step(
          state: currentStep > 10 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 10,
          title: const Text("Confirm and Submit"),
          content: Column(
            children: <Widget>[
              // SizedBox(height: 10),
              const Text(
                'Read TnC',
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: tncAccepted,
                      onChanged: (bool? newValue) {
                        setState(() {
                          tncAccepted = newValue!;
                        });
                      },
                    ),
                    const Text(
                      'I have read the terms and conditions and I accept it!',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ];
}
