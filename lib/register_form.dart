class UserNew
{
  final String email;
  final String password;
  final Set<Role> roles;
  
  UserNew ({required this.email , required this.password , Set<Role>? roles}) : roles = roles ?? {};
}

class Role {
  final String name;
  Role(this.name);
}
