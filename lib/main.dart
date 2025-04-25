import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// Updated credentials to meet new rules
const String correctEmail = 'test@domain.org';
const String correctPassword = 'StrongPass123';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login & Order Form',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}

// Login Screen
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Email validation: must contain "@" and end with ".org"
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Enter email';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  // Password validation: >8 chars, includes uppercase, lowercase, number
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Enter password';
    if (value.length <= 8) return 'Must be more than 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Include uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Include lowercase letter';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Include a number';
    return null;
  }

  void _login() {
    if (_loginFormKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      if (email == correctEmail && password == correctPassword) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login Successful')));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Invalid email or password')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: _validateEmail,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: _validatePassword,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _login, child: Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}

// Order Form
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Order _order = Order();

  String? _validateItem(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an item name';
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter quantity';
    }
    if (int.tryParse(value) == null || int.parse(value) <= 0) {
      return 'Please enter a valid number';
    }
    return null;
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item: ${_order.item}, Quantity: ${_order.quantity}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Form')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                // initialValue: 'Coffee',
                decoration: InputDecoration(
                  labelText: 'Item',
                  hintText: 'Coffee',
                ),
                validator: _validateItem,
                onSaved: (value) => _order.item = value!,
              ),
              TextFormField(
                // initialValue: '2',
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  hintText: '2',
                ),
                keyboardType: TextInputType.number,
                validator: _validateQuantity,
                onSaved:
                    (value) =>
                        _order.quantity = int.tryParse(value ?? '0') ?? 0,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitOrder,
                child: Text('Submit Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Order {
  String item = '';
  int quantity = 0;
}
