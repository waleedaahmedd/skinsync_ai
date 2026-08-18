# Refactor PatientTreatmentRequestsScreen for Summarized List View

The goal is to simplify `PatientTreatmentRequestsScreen` to show a list of treatment requests where each item acts as a summary. The summary will include patient details and a grouped view of requested treatments and their specific areas. Full details will be moved to a dedicated detail screen (already partially implemented).

## User Review Required

> [!IMPORTANT]
> The summary card will now group area chips under their respective treatment chips to show the hierarchy requested ("treatments ki chips or us k anadar k areas ki chips").

## Proposed Changes

### Screens

#### [MODIFY] [patient_treatment_requests_screen.dart](file:///Users/appstirr/Documents/Flutter/skin_sync_mobile_app/skinsync_ai/lib/screens/patient_treatment_requests_screen.dart)
- Simplify the `_buildRequestSummaryCard` to focus on patient info and grouped treatment/area chips.
- Update the layout to group areas under each treatment instead of flattening them in a single `Wrap`.

## Verification Plan

### Manual Verification
- Run the app and navigate to `PatientTreatmentRequestsScreen`.
- Verify that each request shows the patient's name, email, and image.
- Verify that treatments are listed, and under each treatment, the corresponding area chips are shown.
- Click on a request card and verify it navigates to the `PatientTreatmentRequestDetailScreen` with all details.
