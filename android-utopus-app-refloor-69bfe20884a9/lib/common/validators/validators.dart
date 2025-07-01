class FormValidator {
  String? validateEmail(String? email) {
    if (email == null) return null;

    RegExp exp = new RegExp(
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
    Iterable<RegExpMatch> matches = exp.allMatches(email);

    if (email.isEmpty) {
      return "Email can't be empty";
    } else if (email.trim().length == 0) {
      return "Email can't contain only spaces";
    } else if (matches.length <= 0) {
      return "Email is invalid";
    } else {
      return '';
    }
  }

  String? validatePassword(String? password) {
    if (password == null) return null;

    if (password.isEmpty) {
      return "Password can't be empty";
    } else if (password.trim().length == 0) {
      return "Password can't contain only spaces";
    } else if (password.length > 25) {
      return "Password can't contain more than 25 characters";
    } else if (password.length < 8) {
      return "Password must contain at least 8 characters";
    } else {
      return null;
    }
  }

  String? validatePasswords(String? pass, String? confirmPass) {
    if (pass != confirmPass) {
      return "Passwords don't match";
    }

    return null;
  }

  String? isValidMobileNumber(String input) {
    final RegExp regex = RegExp(r'^[0-9]{10}$');

    return regex.hasMatch(input)==true?'':'Invalid Mobile Number';
  }

  String? validateName(String? name) {
    return name!.isNotEmpty ? null : "Name can't be empty";
  }

  String? validateField(String? name) {
    return name!.isNotEmpty ? null : "Field can't be empty";
  }
  String? isValidPIN(String input) {
    final RegExp regex = RegExp(r'^[0-9]{6}$');

    if (regex.hasMatch(input)) {
      return null;
    } else {
      return 'Invalid PIN Code';
    }
  }

  String? validateAccount(String? pass, String? confirmPass) {
    if (pass != confirmPass) {
      return "Passwords don't match";
    }

    return null;
  }

  String? validateGender(String? value) {
    if (value!.isEmpty) {
      return "Gender can't be empty";
    } else if (value.trim().length == 0) {
      return "Gender can't contain only spaces";
    } else if (value.toString()!='male'&&value.toString()!='female') {
      return "Gender is invalid";
    } else {
      return null;
    }
  }

  String? validateAge(String? age) {
    return age!.isNotEmpty ? null : "Age can't be empty";
  }
  bool isValidPAN(String input) {
    final RegExp regex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    return regex.hasMatch(input);
  }


  String? isValidAadhaar(String input) {
    final RegExp regex = RegExp(r'^[0-9]{12}$');
    if (regex.hasMatch(input)) {
      return null;
    } else {
      return 'Invalid Aadhaar card number';
    }
  }

}
extension StringValidationExtension on String? {

  bool get isNotNullOrEmpty {
    var current = this;
    if (current != null) return current.isNotEmpty;

    return false;
  }
}