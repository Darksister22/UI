String translateYearEA(String year) {
  switch (year) {
    case 'first':
      {
        return 'السنة الاولى';
      }
    case 'second':
      {
        return 'السنة الثانية';
      }
    case 'third':
      {
        return 'السنة الثالثة';
      }
    case 'fourth':
      {
        return 'السنة الرابعة';
      }
    case 'fifth':
      {
        return 'السنة الخامسة';
      }
    case 'sixth':
      {
        return 'السنة السادسة';
      }
    case 'seventh':
      {
        return 'السنة السابعة';
      }
    case 'eighth':
      {
        return 'السنة الثامنة';
      }
    case 'ninth':
      {
        return 'السنة التاسعة';
      }
    case 'tenth':
      {
        return 'السنة العاشرة';
      }
    default:
      {
        return '';
      }
  }
}

String translateYearAE(String year) {
  switch (year) {
    case 'السنة الاولى':
      {
        return 'first';
      }
    case 'السنة الثانية':
      {
        return 'second';
      }
    case 'السنة الثالثة':
      {
        return 'third';
      }
    case 'السنة الرابعة':
      {
        return 'fourth';
      }
    case 'السنة الخامسة':
      {
        return 'fifth';
      }
    case 'السنة السادسة':
      {
        return 'sixth';
      }
    case 'السنة السابعة':
      {
        return 'seventh';
      }
    case 'السنة الثامنة':
      {
        return 'eighth';
      }
    case 'السنة التاسعة':
      {
        return 'ninth';
      }
    case 'السنة العاشرة':
      {
        return 'tenth';
      }
    default:
      {
        return '';
      }
  }
}

String translateRoleAE(String role) {
  switch (role) {
    case 'زائر - قراءة فقط':
      {
        return 'guest';
      }
    case 'عضو - قراءة و تعديل':
      {
        return 'admin';
      }
    case 'رئيس - جميع الصلاحيات':
      {
        return 'superadmin';
      }
    default:
      {
        return '';
      }
  }
}

String translateRoleEA(String role) {
  switch (role) {
    case 'guest':
      {
        return 'زائر - قراءة فقط';
      }
    case 'admin':
      {
        return 'عضو - قراءة و تعديل';
      }
    case 'superadmin':
      {
        return 'رئيس - جميع الصلاحيات';
      }
    default:
      {
        return '';
      }
  }
}

String translateLevelAE(String level) {
  switch (level) {
    case 'بكالوريوس':
      {
        return 'bachaelor';
      }
    case 'ماجستير':
      {
        return 'master';
      }
    case 'دكتوراة':
      {
        return 'pHD';
      }
    default:
      {
        return '';
      }
  }
}

String translateLevelEA(String level) {
  switch (level) {
    case 'bachaelor':
      {
        return 'بكالوريوس';
      }
    case 'master':
      {
        return 'ماجستير';
      }
    case 'pHD':
      {
        return 'دكتوراة';
      }
    default:
      {
        return '';
      }
  }
}

String translateNumAE(String number) {
  switch (number) {
    case 'الكورس الاول':
      {
        return 'first';
      }
    case 'الكورس الثاني':
      {
        return 'second';
      }
    default:
      {
        return '';
      }
  }
}

String translateNumEA(String number) {
  switch (number) {
    case 'first':
      {
        return 'الكورس الاول';
      }
    case 'second':
      {
        return 'الكورس الثاني';
      }
    default:
      {
        return '';
      }
  }
}

String translateStsAE(String number) {
  switch (number) {
    case 'ناجح':
      {
        return 'pass';
      }
    case 'راسب':
      {
        return 'fail';
      }
    case 'محمل':
      {
        return 'carry';
      }
    default:
      {
        return 'لا يوجد';
      }
  }
}

String translateStsEA(String number) {
  switch (number) {
    case 'pass':
      {
        return 'ناجح';
      }
    case 'fail':
      {
        return 'راسب';
      }
    case 'carry':
      {
        return 'محمل';
      }
    default:
      {
        return 'لا يوجد';
      }
  }
}
