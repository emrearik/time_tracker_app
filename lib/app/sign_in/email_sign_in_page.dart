import 'package:flutter/material.dart';
import 'package:flutter_time_tracker_app/app/sign_in/sign_in_model.dart';
import 'package:flutter_time_tracker_app/services/auth.dart';
import 'package:provider/provider.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInPage extends StatefulWidget {
  final SignInModel model;
  EmailSignInPage({Key? key, required this.model}) : super(key: key);

  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<SignInModel>(
      create: (_) => SignInModel(auth: auth),
      child: Consumer<SignInModel>(
        builder: (_, model, __) => EmailSignInPage(model: model),
      ),
    );
  }
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  SignInModel get model => widget.model;

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    model.updateWith(isLoading: true, submitted: true);
    try {
      if (model.formType == EmailSignInFormType.signIn) {
        model.auth.signInWithEmailAndPassword(model.email, model.password);
        Navigator.of(context).pop();
      } else {
        model.auth.createUserWithEmailAndPassword(model.email, model.password);
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8),
        labelText: "Email",
        hintText: "test@test.com",
        errorText: model.isLoading ? model.invalidEmailErrorText : null,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      onChanged: model.updateEmail,
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8),
        labelText: "Password",
        hintText: "password",
        errorText: model.isLoading ? model.invalidPasswordErrorText : null,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: model.updatePassword,
    );
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 10),
      _buildPasswordTextField(),
      SizedBox(height: 10),
      MaterialButton(
        onPressed: model.canSubmit ? _submit : () {},
        child: Text(model.primaryButtonText),
        color: Colors.green,
        textColor: Colors.white,
      ),
      SizedBox(height: 10),
      TextButton(
        onPressed: model.toggleFormType,
        child: Text(
          model.secondaryButtonText,
          style: TextStyle(color: Colors.black),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "E-Mail Sign In Page",
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: _buildChildren(),
          ),
        ),
      ),
    );
  }
}
