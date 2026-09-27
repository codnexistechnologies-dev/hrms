import 'package:aeon_hrms/Screens/KPI%20Management/Farmer%20Connectivity%20Entry/view/AddFarmerConnectivityEntry.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Retailer%20Distributor%20Visit%20Entry/view/AddRetailerDistributorVisitEntry.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/controller/DemoPlanController.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/Demo%20Plan/model/ProductMasterListModel.dart';
import 'package:aeon_hrms/Screens/KPI%20Management/widgets/contact_entry_form_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('farmer form contains schema fields without sample values', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(home: AddFarmerConnectivityEntry()),
    );
    expect(find.text('Farmer Connectivity Entry'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Farmer Name',
      ),
      findsOneWidget,
    );

    for (final fieldKey in [
      'master-field-Product Name',
      'master-field-Crop',
      'master-field-State',
      'master-field-District',
      'master-field-Tehsil',
      'master-field-Village',
      'contact-form-PINCODE',
      'contact-form-PURPOSE',
      'contact-form-ACREAGE',
      'contact-form-PRODUCT_DISCUSSED',
      'contact-form-FARMER_INTEREST',
      'other-product-discuss-picker',
      'contact-form-REMARKS',
      'contact-form-ADDRESS',
    ]) {
      final field = find.byKey(ValueKey(fieldKey));
      expect(field, findsOneWidget);
    }

    final contactType = find.byKey(const ValueKey('contact-form-CONTACT_TYPE'));
    expect(contactType, findsOneWidget);
    expect(find.text('Sample Farmer'), findsNothing);
  });

  testWidgets('farmer save disables while submission is active', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: AddFarmerConnectivityEntry()),
    );
    final state = tester
        .state<ContactEntryFormState<AddFarmerConnectivityEntry>>(
          find.byType(AddFarmerConnectivityEntry),
        );
    state.setState(() => state.saving = true);
    await tester.pump();

    final saveButtonFinder = find.byType(FilledButton);
    await tester.scrollUntilVisible(
      saveButtonFinder,
      250,
      scrollable: find.byType(Scrollable).first,
    );
    final saveButton = tester.widget<FilledButton>(saveButtonFinder);
    expect(saveButton.onPressed, isNull);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('retailer order defaults to No and validates decimal precision', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: AddRetailerDistributorVisitEntry()),
    );
    final visitType = find.byKey(const ValueKey('visit-type-dropdown'));
    await tester.tap(visitType);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retailer').last);
    await tester.pumpAndSettle();

    final order = find.byType(DropdownButtonFormField<bool>);
    await tester.scrollUntilVisible(
      order,
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      tester.widget<DropdownButtonFormField<bool>>(order).initialValue,
      false,
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.labelText == 'Order Value',
      ),
      findsNothing,
    );
    await tester.tap(order);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes').last);
    await tester.pumpAndSettle();
    final value = find.byWidgetPredicate(
      (w) => w is TextField && w.decoration?.labelText == 'Order Value',
    );
    await tester.ensureVisible(value);
    final state = tester.state<FormState>(find.byType(Form));
    expect(state.validate(), true);
    await tester.enterText(value, '123.456');
    expect(state.validate(), false);
    await tester.enterText(value, '123.45');
    expect(state.validate(), true);
  });

  testWidgets('retailer form contains its complete field set', (tester) async {
    tester.view.physicalSize = const Size(800, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(home: AddRetailerDistributorVisitEntry()),
    );

    for (final fieldKey in [
      'master-field-Product Name',
      'visit-type-dropdown',
      'contact-form-CONTACT_PERSON',
      'order-taken-dropdown',
      'contact-form-STOCK_AVAILABLE',
      'contact-form-PRODUCT_DISCUSSED',
      'other-product-discuss-picker',
      'contact-form-COMPETITOR_PRODUCT',
      'contact-form-SCHEME_DISCUSSED',
      'contact-form-MARKET_FEEDBACK',
      'contact-form-REMARKS',
    ]) {
      expect(find.byKey(ValueKey(fieldKey)), findsOneWidget);
    }
    for (final fieldKey in [
      'master-field-Crop',
      'master-field-State',
      'master-field-District',
      'master-field-Tehsil',
      'master-field-Village',
      'contact-form-PINCODE',
      'contact-form-MOBILE_NO',
      'contact-form-CUSTOMER_ID',
      'contact-form-PURPOSE',
      'contact-form-UPLOAD_FILE',
      'contact-form-ADDRESS',
    ]) {
      expect(find.byKey(ValueKey(fieldKey)), findsNothing);
    }
    expect(find.text('Select Follow-up Date'), findsOneWidget);
    expect(find.text('Upload Photo'), findsWidgets);
    expect(find.text('Capture Current Location'), findsOneWidget);
    expect(find.text('Latitude / Longitude'), findsWidgets);
    expect(
      find.byKey(const ValueKey('contact-form-FARMER_NAME')),
      findsNothing,
    );
    expect(find.byKey(const ValueKey('contact-form-ACREAGE')), findsNothing);
  });

  testWidgets('retailer visit type is a retailer or distributor dropdown', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: AddRetailerDistributorVisitEntry()),
    );
    final visitType = find.byKey(const ValueKey('visit-type-dropdown'));
    await tester.scrollUntilVisible(
      visitType,
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(visitType, findsOneWidget);
    expect(find.text('Select Visit Type'), findsNothing);

    await tester.tap(visitType);
    await tester.pumpAndSettle();
    expect(find.text('Retailer'), findsOneWidget);
    expect(find.text('Distributor'), findsOneWidget);
  });

  testWidgets('retailer other discussed products supports multi-select', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = Get.put(DemoPlanController());
    controller.productList.assignAll([
      ProductData(productCode: 101, productName: 'Product Alpha'),
      ProductData(productCode: 202, productName: 'Product Beta'),
    ]);
    await tester.pumpWidget(
      const MaterialApp(home: AddRetailerDistributorVisitEntry()),
    );

    expect(
      find.byKey(const ValueKey('master-field-Product Name')),
      findsOneWidget,
    );
    final picker = find.byKey(const ValueKey('other-product-discuss-picker'));
    await tester.ensureVisible(picker);
    await tester.tap(picker);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('other-product-option-101')));
    await tester.tap(find.byKey(const ValueKey('other-product-option-202')));
    await tester.tap(find.byKey(const ValueKey('other-product-discuss-done')));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<Text>(
            find.byKey(const ValueKey('other-product-discuss-summary')),
          )
          .data,
      'Product Alpha, Product Beta',
    );
  });
}
