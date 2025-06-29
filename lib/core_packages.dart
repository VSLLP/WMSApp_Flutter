import 'package:epicor/src/services/repository/auth_services.dart';
import 'package:epicor/src/services/repository/custship_services.dart';
import 'package:epicor/src/services/repository/insp_services.dart';
import 'package:epicor/src/services/repository/inventory_services.dart';
import 'package:epicor/src/services/repository/jobtoinvServices.dart';
import 'package:epicor/src/services/repository/material_services.dart';
import 'package:epicor/src/services/repository/spref_services.dart';
import 'package:epicor/src/services/repository/transfer_services.dart';
import 'package:epicor/src/services/repository/util_services.dart';
import 'package:epicor/src/services/repository/custshipment_services.dart';

export 'dart:async';
export 'dart:convert';
export 'dart:io';

export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:permission_handler/permission_handler.dart';
export 'package:provider/provider.dart';
export 'package:lottie/lottie.dart';
export 'package:swipe_refresh/swipe_refresh.dart';
export 'package:skeletonizer/skeletonizer.dart';
export 'package:flutter_svg/svg.dart';

export 'package:epicor/src/config/style/style.dart';

final SharedPref sharedPref = SharedPref();
final AuthDelegate authServices = AuthDelegate();
final InventoryDelegate inventoryServices = InventoryDelegate();
final TransferDelegate transferServices = TransferDelegate();
final MaterialDelegate materialServices = MaterialDelegate();
final UtilDelegate utilServices = UtilDelegate();
final IsnpDelegate isnpServices = IsnpDelegate();
final JobToInvDelegate jobinvServices = JobToInvDelegate();
final CustShipDelegate custShipServices = CustShipDelegate();
