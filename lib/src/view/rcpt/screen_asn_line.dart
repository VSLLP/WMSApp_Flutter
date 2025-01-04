import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';

class ScreenAsnLine extends StatefulWidget {
  final dynamic item;
  final String packNum;

  const ScreenAsnLine({
    super.key,
    required this.item,
    required this.packNum,
  });

  @override
  State<ScreenAsnLine> createState() => _ScreenAsnLineState();
}

class _ScreenAsnLineState extends State<ScreenAsnLine> {
  List<dynamic> productItems = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenNetwork(
        child: Scaffold(
          backgroundColor: AppColors.colorWhite,
          body: ScreenBackground(
            isLoading: isLoading,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 22,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: 30,
                              height: 30,
                              child: Center(
                                child: Icon(
                                  Icons.keyboard_backspace_rounded,
                                  size: 28,
                                  color: AppColors.colorBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Receipt Details',
                            style: TextStyles.getBold(
                              22,
                              color: AppColors.colorWhite,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.colorWhite,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.colorTansprent20,
                                  blurRadius: 4,
                                  offset: const Offset(-4, 4),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    color: Colors.transparent,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Table(
                                        columnWidths: const {
                                          0: FixedColumnWidth(50),
                                          1: FixedColumnWidth(280),
                                          2: FixedColumnWidth(100),
                                          3: FixedColumnWidth(100),
                                        },
                                        border: const TableBorder.symmetric(
                                          inside: BorderSide(
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                        children: getRows(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.colorBlue300,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Total Items: ${getTotal()}",
                                    style: TextStyles.getBold(14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  loadData() async {
    var res = await inventoryServices.getReceiptLines(widget.packNum);
    productItems.clear();
    productItems = res['value'];
    setState(() {
      isLoading = false;
    });
  }

  List<TableRow> getRows() {
    List<TableRow> rows = [];
    rows.add(TableRow(
      children: [
        tableCell('Line'),
        tableCell('Product'),
        tableCell('Rec Qty'),
        tableCell('Ord Qty'),
      ],
    ));
    for (int i = 0; i < productItems.length; i++) {
      var item = productItems[i];
      rows.add(
        TableRow(
          children: [
            tableCellRow(item['RcvDtl_PackLine'].toString()),
            tableCellRow(
                "${item['RcvDtl_PartNum']}\n${item['RcvDtl_PartDescription']}"),
            tableCellRow(
              double.parse(item["RcvDtl_OurQty"].toString()).toStringAsFixed(2),
            ),
            tableCellRow(
              double.parse(item["RcvDtl_VendorQty"].toString())
                  .toStringAsFixed(2),
            ),
          ],
        ),
      );
    }
    return rows;
  }

  Widget tableCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            text,
            style: TextStyles.getBold(
              14,
              color: AppColors.colorDataColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget tableCellRow(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyles.getRegularScund(14),
        ),
      ),
    );
  }

  getTotal() {
    double total = 0;
    for (var item in productItems) {
      total = total + double.parse(item['RcvDtl_OurQty'].toString());
    }
    return total.toStringAsFixed(2);
  }
}
