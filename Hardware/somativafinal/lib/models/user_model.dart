// lib/models/user_model.dart

class UserModel {
  final String uid;
  final String email;
  final String senha;

  UserModel({
    required this.uid,
    required this.email,
    required this.senha,
  });

  // Criar UserModel a partir de um Map (Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] as String,
      senha: map['senha'] as String,
    );
  }

  // Converter para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'senha': senha,
    };
  }
}
