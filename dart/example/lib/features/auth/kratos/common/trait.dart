enum Trait {
  email('email'),
  givenName('given_name'),
  familyName('family_name'),
  regulationsAccepted('regulations_accepted');

  const Trait(this.key);

  final String key;
}
