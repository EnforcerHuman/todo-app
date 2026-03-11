class AppConfig {
  const AppConfig._();

  static const firebaseDatabaseUrl = String.fromEnvironment(
    'FIREBASE_DB_URL',
    defaultValue: 'https://hey-style-default-rtdb.firebaseio.com/',
  );
}
