import '../models/responses/simulation_history_response.dart';
import '../models/treatment_price_model.dart';


class PriceUtils {
  static List<TreatmentPriceResult> calculateTreatmentPrices(
    List<SimulationTreatment> treatments,
  ) {
    return treatments.map((treatment) {
      num treatmentTotal = 0;

      for (final area in treatment.areas ?? <SimulationArea>[]) {
        final num areaPrice = area.price ?? 0;

        int totalQuantity = 0;

        for (final material
            in area.materials ?? <SimulationMaterial>[]) {
          totalQuantity += material.selectedQuantity ?? 0;
        }

        if (totalQuantity == 0) {
          treatmentTotal += areaPrice;
        } else {
          treatmentTotal += areaPrice * totalQuantity;
        }
      }

      return TreatmentPriceResult(
        name: treatment.name,
        totalPrice: treatmentTotal,
      );
    }).toList();
  }

  static num calculateGrandTotal(
  List<SimulationTreatment> treatments,
) {
  final treatmentPrices = calculateTreatmentPrices(treatments);

  return treatmentPrices.fold<num>(
    0,
    (total, treatment) => total + treatment.totalPrice,
  );
}
}