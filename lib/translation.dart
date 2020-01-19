import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_minyan/l10n/messages_all.dart';

class Translations {
  static Future<Translations> load(Locale locale) {
    final String name =
    (locale.countryCode != null && locale.countryCode.isEmpty)
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((dynamic _) {
      Intl.defaultLocale = localeName;
      return new Translations();
    });
  }

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  ///menu_screen--------------------------------
  String get minianFinder {
    return Intl.message(
      'Buscador de minian',
      name: 'minianFinder',
    );
  }
  String get minianTitle {
    return Intl.message(
      'Minian',
      name: 'minianTitle',
    );
  }
  String get newMinyan {
    return Intl.message(
      'Nuevo',
      name: 'newMinyan',
    );
  }
  String get about {
    return Intl.message(
      'Info',
      name: 'about',
    );
  }
  String get menuTitle {
    return Intl.message(
      'Inicio',
      name: 'menuTitle',
    );
  }
  String get changePassword {
    return Intl.message(
      'Cambiar contraseña',
      name: 'changePassword',
    );
  }
  String get welcome {
    return Intl.message(
      'Bienvenido',
      name: 'welcome',
    );
  }
  String get goMinyan {
    return Intl.message(
      'Go Minyan',
      name: 'goMinyan',
    );
  }
  String get loginItem {
    return Intl.message(
      'Cuenta',
      name: 'loginItem',
    );
  }
  String get settings {
    return Intl.message(
      'Configuracion',
      name: 'settings',
    );
  }
///menu_screen-------------------------------
///info_screen--------------------------------
  String get aboutTitle {
    return Intl.message(
      'Informacion',
      name: 'aboutTitle',
    );
  }
  String get appTitle {
    return Intl.message(
      'Go Minyan App',
      name: 'appTitle',
    );
  }
  String get appDesc {
    return Intl.message(
      'Una app creada sin fines de lucro con el objetivo de proveer al usuario la facilidad de encontrar el lugar indicado a la hora indicada para rezar. Que sea para refua shlema de todos los enfermos de AM ISRAEL.',
      name: 'appDesc',
    );
  }
  String get emailMe {
    return Intl.message(
      'Enviar un email',
      name: 'emailMe',
    );
  }
  String get donateMe {
    return Intl.message(
      'Contribuir a este proyecto',
      name: 'donateMe',
    );
  }
  String get aboutGoMinyan {
    return Intl.message(
      'Sobre Go Minyan',
      name: 'aboutGoMinyan',
    );
  }
  String get copyright {
    return Intl.message(
      '© 2019, GoMinyan',
      name: 'copyright',
    );
  }
///info_screen--------------------------------
///new-minian--------------------------------
  String get newMinianTitle {
    return Intl.message(
      'Pedir nuevo minian',
      name: 'newMinianTitle',
    );
  }
  String get submit {
    return Intl.message(
      'Enviar',
      name: 'submit',
    );
  }
  String get name {
    return Intl.message(
      'Nombre',
      name: 'name',
    );
  }
  String get nameValid {
    return Intl.message(
      'Ingrese un nombre',
      name: 'nameValid',
    );
  }
  String get instValid {
    return Intl.message(
      'Ingrese un nombre de institucion',
      name: 'instValid',
    );
  }
  String get phoneValid {
    return Intl.message(
      'Ingrese un telefono de contacto',
      name: 'phoneValid',
    );
  }
  String get emailValid {
    return Intl.message(
      'Ingrese un email valido',
      name: 'emailValid',
    );
  }
  String get formError {
    return Intl.message(
      'El formulario ingresado no es correcto, por favor revise y vuelva a enviarlo.',
      name: 'formError',
    );
  }
  String get errorFormName {
    return Intl.message(
      'Por favor ingrese solamente caracteres alfabeticos.',
      name: 'errorFormName',
    );
  }
  String get passNotMatch {
    return Intl.message(
      'Contraseñas no coinciden',
      name: 'passNotMatch',
    );
  }
  String get emailSent {
    return Intl.message(
      'Hemos recibido su mensaje, pronto lo estaremos contactando.',
      name: 'emailSent',
    );
  }
  String get emailNotSent {
    return Intl.message(
      'Hubo un error al enviar. Revise su conexion y vuelva a intentarlo.',
      name: 'emailNotSent',
    );
  }
///new-minian--------------------------------

///google_map_screen--------------------------------
  String get mapLoading {
    return Intl.message(
      'Cargando mapa...',
      name: 'mapLoading',
    );
  }
  String get searchTitle {
    return Intl.message(
      'Buscar',
      name: 'searchTitle',
    );
  }
  String get searchResults {
    return Intl.message(
      'Resultados',
      name: 'searchResults',
    );
  }
  String get btnNearMe {
    return Intl.message(
      'Filtrar distancia',
      name: 'btnNearMe',
    );
  }
  String get btnMapView {
    return Intl.message(
      'Cambiar vista',
      name: 'btnMapView',
    );
  }
  String get btnNow {
    return Intl.message(
      'Proximo minian',
      name: 'btnNow',
    );
  }
///google_map_screen--------------------------------

///marker_detail_screen--------------------------------
  String get detailTitle {
    return Intl.message(
      'Informacion tefilot',
      name: 'detailTitle',
    );
  }
  String get callButton {
    return Intl.message(
      'Llamar',
      name: 'callButton',
    );
  }
  String get dataLoading {
    return Intl.message(
      'Cargando datos...',
      name: 'dataLoading',
    );
  }
  String get notification {
    return Intl.message(
      'Notificaciones',
      name: 'notification',
    );
  }
  String get minutesBefore {
    return Intl.message(
      'min antes',
      name: 'minutesBefore',
    );
  }
  String get notificationReminder {
    return Intl.message(
      'Recordatorio de notificacion',
      name: 'notificationReminder',
    );
  }
  String get map {
    return Intl.message(
      'Mapa',
      name: 'map',
    );
  }
  String get updateMapData {
    return Intl.message(
      'Actualizar datos del mapa',
      name: 'updateMapData',
    );
  }
  String get update {
    return Intl.message(
      'Actualizar',
      name: 'update',
    );
  }
  String get updating {
    return Intl.message(
      'Actualizando',
      name: 'updating',
    );
  }
  String get nusachTitle {
    return Intl.message(
      'Nusach',
      name: 'nusachTitle',
    );
  }
///marker_detail_screen--------------------------------

///login--------------------------------
  String get btnLogin {
    return Intl.message(
      'Entrar',
      name: 'btnLogin',
    );
  }
  String get emailHint {
    return Intl.message(
      'Email',
      name: 'emailHint',
    );
  }
  String get passHint {
    return Intl.message(
      'Contraseña',
      name: 'passHint',
    );
  }
  String get newPass {
    return Intl.message(
      'Nueva Contraseña',
      name: 'newPass',
    );
  }
  String get repeatPassHint {
    return Intl.message(
      'Repetir Contraseña',
      name: 'repeatPassHint',
    );
  }
  String get invalidMail {
    return Intl.message(
      'Email invalido',
      name: 'invalidMail',
    );
  }
  String get invalidPass {
    return Intl.message(
      'Contraseña debe contener 8 caracteres alfanumericos',
      name: 'invalidPass',
    );
  }
  String get loginTitle {
    return Intl.message(
      'Administradores',
      name: 'loginTitle',
    );
  }
  String get loginLoading {
    return Intl.message(
      'Iniciando...',
      name: 'loginLoading',
    );
  }
  String get loginFailure {
    return Intl.message(
      'Acceso incorrecto',
      name: 'loginFailure',
    );
  }
///login--------------------------------

///register--------------------------------
  String get registerTitle {
    return Intl.message(
      'Registrar Usuario',
      name: 'registerTitle',
    );
  }
  String get btnClear {
    return Intl.message(
      'Borrar',
      name: 'btnClear',
    );
  }
  String get btnRegister {
    return Intl.message(
      'Registrar Usuario',
      name: 'btnRegister',
    );
  }
  String get errorDialog {
    return Intl.message(
      'Error',
      name: 'errorDialog',
    );
  }
  String get registerSuccess {
    return Intl.message(
      'Registro Exitoso',
      name: 'registerSuccess',
    );
  }
  String get registerLoading {
    return Intl.message(
      'Registrando...',
      name: 'registerLoading',
    );
  }
  String get successDialogTitle {
    return Intl.message(
      'Exitoso',
      name: 'successDialogTitle',
    );
  }
  String get successDialogContent {
    return Intl.message(
      'Se han cargado los datos',
      name: 'successDialogContent',
    );
  }
  String get btnDialog {
    return Intl.message(
      'Volver',
      name: 'btnDialog',
    );
  }
///register--------------------------------
  String get sunday {
    return Intl.message(
      'Domingo',
      name: 'sunday',
    );
  }
  String get monday {
    return Intl.message(
      'Lunes',
      name: 'monday',
    );
  }
  String get tuesday {
    return Intl.message(
      'Martes',
      name: 'tuesday',
    );
  }
  String get wednesday {
    return Intl.message(
      'Miercoles',
      name: 'wednesday',
    );
  }
  String get thursday {
    return Intl.message(
      'Jueves',
      name: 'thursday',
    );
  }
  String get friday {
    return Intl.message(
      'Viernes',
      name: 'friday',
    );
  }
  String get day {
    return Intl.message(
      'Dia',
      name: 'day',
    );
  }
///schedule--------------------------------

///schedule--------------------------------
///admin_screen--------------------------------
  String get adminPageTitle {
    return Intl.message(
      'Administracion',
      name: 'adminPageTitle',
    );
  }
  String get logOut {
    return Intl.message(
      'Cerrar sesion',
      name: 'logOut',
    );
  }
  String get btnEditorTimes {
    return Intl.message(
      'Editar horarios',
      name: 'btnEditorTimes',
    );
  }
  String get lblName {
    return Intl.message(
      'Nombre Institucional: ',
      name: 'lblName',
    );
  }
  String get lblContact {
    return Intl.message(
      'Telefono de contacto: ',
      name: 'lblContact',
    );
  }
  String get lblAddress {
    return Intl.message(
      'Direccion: ',
      name: 'lblAddress',
    );
  }
  String get btnSave {
    return Intl.message(
      'Guardar',
      name: 'btnSave',
    );
  }
  String get btnNusach {
    return Intl.message(
      'Seleccionar Nusach',
      name: 'btnNusach',
    );
  }
  String get btnRestore {
    return Intl.message(
      'Restaurar',
      name: 'btnRestore',
    );
  }
  String get lblEmailRestoreSent {
    return Intl.message(
      'Se envio un mail para restaurar contraseña',
      name: 'lblEmailRestoreSent',
    );
  }
  String get restoreMsg {
    return Intl.message(
      'Datos restaurados.',
      name: 'restoreMsg',
    );
  }
  String get saveMsg {
    return Intl.message(
      'Datos guardaados.',
      name: 'saveMsg',
    );
  }
  String get connectionError {
    return Intl.message(
      'No hay conexion a internet',
      name: 'connectionError',
    );
  }
  String get emailNotExist {
    return Intl.message(
      'No existe el email ingreaado',
      name: 'emailNotExist',
    );
  }
///admin_screen--------------------------------

///admin_times_screen--------------------------------
  String get prayTimeTitle {
    return Intl.message(
      'Horarios tefilot',
      name: 'prayTimeTitle',
    );
  }
  String get lblDescriptionPray {
    return Intl.message(
      'Horarios que actualmente se muestra en aplicacion ',
      name: 'lblDescriptionPray',
    );
  }
  String get btnAdd {
    return Intl.message(
      'Agregar',
      name: 'btnAdd',
    );
  }
  String get btnAccept {
    return Intl.message(
      'Aceptar',
      name: 'btnAccept',
    );
  }
  String get btnNew {
    return Intl.message(
      'Nuevo',
      name: 'btnNew',
    );
  }
  String get shabatTitle {
    return Intl.message(
      'Shabat',
      name: 'shabatTitle',
    );
  }
  String get shajaritTitle {
    return Intl.message(
      'Shajarit',
      name: 'shajaritTitle',
    );
  }
  String get minjaTitle {
    return Intl.message(
      'Minja',
      name: 'minjaTitle',
    );
  }
  String get arvitTitle {
    return Intl.message(
      'Arvit',
      name: 'arvitTitle',
    );
  }
  String get lblNoData {
    return Intl.message(
      'Sin datos',
      name: 'lblNoData',
    );
  }
  String get hintDDLabel {
    return Intl.message(
      'Elige',
      name: 'hintDDLabel',
    );
  }
  String get adminDialogContentError {
    return Intl.message(
      'Debe seleccionar horario y dia',
      name: 'adminDialogContentError',
    );
  }
  String get popupTitle {
    return Intl.message(
      'Nuevo horario',
      name: 'popupTitle',
    );
  }
  String get btnPopupTime {
    return Intl.message(
      'Seleccionar hora',
      name: 'btnPopupTime',
    );
  }
  String get lblSelectedTime {
    return Intl.message(
      'Hora seleccionada: ',
      name: 'lblSelectedTime',
    );
  }
///admin_times_screen--------------------------------

///splash_screen--------------------------------
  String get splashText {
    return Intl.message(
      'Cargando...',
      name: 'splashText',
    );
  }
///splash_screen--------------------------------

///setting_screen--------------------------------
  String get english {
    return Intl.message(
      'Ingles',
      name: 'english',
    );
  }
  String get spanish {
    return Intl.message(
      'Español',
      name: 'spanish',
    );
  }
  String get language {
    return Intl.message(
      'Idioma',
      name: 'language',
    );
  }
  String get languageContent {
    return Intl.message(
      'Seleccione el idioma preferido',
      name: 'languageContent',
    );
  }
  String get displayTitle {
    return Intl.message(
      'Vista de configuracion',
      name: 'displayTitle',
    );
  }
  String get darkMode {
    return Intl.message(
      'Modo oscuro',
      name: 'darkMode',
    );
  }
///setting_screen--------------------------------
///nearBy BTN--------------------------------
  String get contentNotFindNearBy {
    return Intl.message(
      'No se encontraron minianim a menos de ',
      name: 'contentNotFindNearBy',
    );
  }
  String get contentNotFindNow {
    return Intl.message(
      'No se encontraron minianim ahora.',
      name: 'contentNotFindNow',
    );
  }
  String get contentFindNearBy {
    return Intl.message(
      'Cantidad encontrada: ',
      name: 'contentFindNearBy',
    );
  }
  String get dialogNearByTitle {
    return Intl.message(
      'Ingrese el valor en metros',
      name: 'dialogNearByTitle',
    );
  }
  String get dialogNearByHint {
    return Intl.message(
      'Ingrese metros',
      name: 'dialogNearByHint',
    );
  }
  String get btnBack {
    return Intl.message(
      'Volver',
      name: 'btnBack',
    );
  }
  String get btnForgot {
    return Intl.message(
      'Olvide la contraseña',
      name: 'btnForgot',
    );
  }
  String get btnReset {
    return Intl.message(
      'Restaurar',
      name: 'btnReset',
    );
  }
  String get lblForgot {
    return Intl.message(
      'Restaurar contraseña',
      name: 'lblForgot',
    );
  }
  String get searching {
    return Intl.message(
      'Buscando',
      name: 'searching',
    );
  }
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
    );
  }
///nearBy BTN--------------------------------
///FLUTTER NOTIFICATION--------------------------------
  String get pushTitle {
    return Intl.message(
      'Proximo evento',
      name: 'pushTitle',
    );
  }
  String get remember {
    return Intl.message(
      'Recordatorio',
      name: 'remember',
    );
  }
///FLUTTER NOTIFICATION--------------------------------
}
class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es', 'he'].contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) => Translations.load(locale);

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}