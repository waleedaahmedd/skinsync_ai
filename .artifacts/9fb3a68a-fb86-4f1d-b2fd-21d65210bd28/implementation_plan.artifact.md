# Fix Share Button to Bottom in TreatmentJourneyDetailScreen

The user wants the "Share this Option" (or "Select this Option") button in `TreatmentJourneyDetailScreen` to be fixed at the bottom of the screen, similar to other screens in the app. Currently, it is part of the `SimulationCard` and scrolls with the content.

## Proposed Changes

### [Component Name]

#### [MODIFY] [treatment_journey_detail_screen.dart](file:///Users/appstirr/Documents/Flutter/skin_sync_mobile_app/skinsync_ai/lib/screens/treatment_journey_detail_screen.dart)

- Remove the action button from `SimulationCard` by setting `showActionButton: false`.
- Add a `bottomNavigationBar` to the `Scaffold`.
- The `bottomNavigationBar` will contain the `CustomButton` with the same logic as before.
- Ensure the button is only displayed when simulations are loaded for the current option.
- Apply consistent padding and styling as seen in other screens (e.g., `treatment_payment_screen.dart`).

## Verification Plan

### Manual Verification
- Open `TreatmentJourneyDetailScreen`.
- Verify that the "Share this Option" / "Select this Option" button is fixed at the bottom and does not scroll with the content.
- Verify that switching tabs updates the button (if applicable) or handles state correctly.
- Verify that tapping the button still performs the expected action (sharing or navigating to clinics).
- Check the UI for different screen sizes to ensure it doesn't overlap or look broken.
