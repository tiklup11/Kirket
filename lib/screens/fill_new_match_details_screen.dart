import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

// import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';

class FillNewMatchDetailsPage extends StatelessWidget {
  const FillNewMatchDetailsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Match Details"),
      ),
      body: const TextFormFieldDemo(),
    );
  }
}

class TextFormFieldDemo extends StatefulWidget {
  const TextFormFieldDemo({Key key}) : super(key: key);

  @override
  TextFormFieldDemoState createState() => TextFormFieldDemoState();
}

class PersonData {
  String name = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _obscureText
                ? "Temp21"
                : "Temp22",
          ),
        ),
      ),
    );
  }
}

class TextFormFieldDemoState extends State<TextFormFieldDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PersonData person = PersonData();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
  GlobalKey<FormFieldState<String>>();

  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidateMode =
          AutovalidateMode.always; // Start validating on every change.
      showInSnackBar(
        "Please fix errors",
      );
    } else {
      form.save();
      showInSnackBar("Temp6");
    }
  }

  String _validateName(String value) {
    if (value.isEmpty) {
      return "Temp1";
    }
    final nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return "Temp2";
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);

    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: Scrollbar(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                sizedBoxSpace,
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    filled: true,
                    icon: const Icon(Icons.whatshot_rounded),
                    hintText: "Enter team 1 name",
                    labelText:
                    "Team 1",
                  ),
                  onSaved: (value) {
                    person.name = value;
                  },
                  validator: _validateName,
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    icon: const Icon(Icons.sports_baseball_sharp),
                    hintText: "Enter team 2 name",
                    labelText: "Team 2",
                    // prefixText: '+1 ',
                  ),
                  // keyboardType: TextInputType.phone,
                  onSaved: (value) {
                    person.phoneNumber = value;
                  },
                  // maxLength: 14,
                  maxLengthEnforced: false,
                  // validator: _validatePhoneNumber,
                  // TextInputFormatters are applied in sequence.
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    // Fit the validating format.
                    // _phoneNumberFormatter,
                  ],
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    icon: const Icon(Icons.create),
                    hintText: "Players in one team",
                    labelText:
                    "Players Count",
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    person.email = value;
                  },
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    icon: const Icon(Icons.sports_handball),
                    hintText: "Number of overs",
                    labelText:
                    "Overs Count",
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    person.email = value;
                  },
                ),
                sizedBoxSpace,
                Center(
                  child: RaisedButton(
                    child: Text(
                        "Create Match"),
                    onPressed: (){
                      _handleSubmitted();
                      //TODO: take to SCORE_COUNTER_PAGE
                    },
                  ),
                ),
                sizedBoxSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
