import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tatadelearapp/vehicle_RFQ/list_RFQ.dart';
import 'package:tatadelearapp/vehicle_part_order/parts_order_list2.dart';
import 'package:url_strategy/url_strategy.dart';
import 'bloc/bloc.dart';
import 'classes/arguments_classes/arguments_classes.dart';
import 'classes/motows_routes.dart';
import 'company_management/list_companies.dart';
import 'dashboard/home_screen.dart';
import 'firebase_options.dart';


 main() async {
  setPathUrlStrategy();
  try{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  catch (e){
    print(e.toString());
    log(e.toString());
  }
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  PageController page = PageController();
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'Tata Dealer Application',
        initialRoute: "/",
        onGenerateRoute: (RouteSettings settings){
          Widget newScreen;
          switch (settings.name){
            case MotowsRoutes.listFRQ:{
              ListRFQArgs listFRQ;
              if(settings.arguments!=null){
                listFRQ = settings.arguments as ListRFQArgs ;
              }
              else {
                listFRQ = ListRFQArgs(drawerWidth: 190, selectedDestination: 1.1);
              }
              newScreen= ListRFQ(args: listFRQ);
            }
            break;
            case MotowsRoutes.partsOrderListRoutes :
              {
                PartsOrderListArguments2 poListArgs;
                if(settings.arguments!=null){
                  poListArgs = settings.arguments as PartsOrderListArguments2 ;
                }
                else {
                  poListArgs = PartsOrderListArguments2(
                      drawerWidth: 190, selectedDestination: 1.2);
                }
                newScreen = PartsOrderList2(args: poListArgs );
              }
              break;
            case MotowsRoutes.companyManagement:
              {
                CompanyManagementArguments companyManagementArguments;
                if(settings.arguments!=null){
                  companyManagementArguments = settings.arguments as CompanyManagementArguments ;
                }
                else {
                  companyManagementArguments = CompanyManagementArguments(
                      drawerWidth: 190, selectedDestination: 3.1);
                }
                newScreen = CompanyManagement(args: companyManagementArguments);
              }
              break;

            default: newScreen = const InitialScreen();
          }
          return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => newScreen,
              reverseTransitionDuration: Duration.zero,transitionDuration: Duration.zero,settings: settings);
        },
        routes: {
          '/':(context)=> const InitialScreen(),
        },
        theme: ThemeData(
            useMaterial3: true,

           // colorScheme: ColorScheme(background:primaryColor, brightness: Brightness.dark, primary: Colors.black, onPrimary: Colors.black, secondary: Colors.blue, onSecondary: Colors.black, error: primaryColor, onError: primaryColor, onBackground: Colors.black, surface: Colors.blue, onSurface: primaryColor),
            //fontFamily: 'TitilliumWeb'
        ),
        debugShowCheckedModeBanner: false,

    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {


  String?  authToken;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    getLoginData().whenComplete(() {
      isLoading=false;
    });
  }


   getLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('role')=="Admin") {
      bloc.setSubRole(true);
    }
    if(prefs.getString('role')=="Manager") {
      bloc.setMangerRole(true);
    }
    setState(() {
      authToken = prefs.getString("authToken")??"";
      isLoading=false;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      isLoading
          ? const Center(child: SizedBox(width: 100,height: 100,child: CircularProgressIndicator()))
          : authToken == ""
          ? const MyHomePage():  const MyHomePage(),
      //ListPurchaseOrder(drawerWidth: 190,selectedDestination: 4.2, title: 1,)

    );
  }
}
