# Google Play listing — RVM Student (student_app #74)

The console itself is Prakash's account. This file holds Rishi's content so the
listing can be pasted in without drafting anything on the day.

Package: `com.rvm.rvmstudent` · Android only · target audience 18+.

## Store listing

**App name (both languages):** RVM Student

**Short description (English, 80 max):**
Your RVM classes, fees, videos, quizzes and placement — in one app.

**Short description (Hindi):**
आपकी RVM क्लासें, फीस, वीडियो, क्विज़ और प्लेसमेंट — एक ही ऐप में।

**Full description (English):**
RVM Student is for students and alumni of RVM CAD. Sign in with the phone
number on your admission record to:

- see your timetable, attendance and classes;
- check fees, receipts and payment status;
- watch your recorded lectures and live classes, with views counted by RVM;
- take quizzes, practice tests and mock interviews;
- raise a complaint and follow the reply;
- use the community board and polls;
- see placement proof and your payout account;
- open RVM Campus jobs when your placement team opens them.

Your phone number and admission details stay with RVM. Videos are protected
and cannot be downloaded, shared or recorded.

**Full description (Hindi):**
RVM Student उन विद्यार्थियों और पूर्व-विद्यार्थियों के लिए है जो RVM CAD से जुड़े
हैं। अपने प्रवेश रिकॉर्ड वाले फ़ोन नंबर से साइन इन करें और देखें:

- अपनी टाइमटेबल, उपस्थिति और क्लासें;
- फीस, रसीदें और भुगतान की स्थिति;
- अपने रिकॉर्ड किए गए लेक्चर और लाइव क्लासें;
- क्विज़, अभ्यास परीक्षा और मॉक इंटरव्यू;
- शिकायत दर्ज करें और उसका जवाब देखें;
- कम्युनिटी बोर्ड और पोल;
- प्लेसमेंट प्रमाण और अपना पेआउट खाता;
- जब आपकी प्लेसमेंट टीम खोले, तब RVM Campus की नौकरियाँ।

आपका फ़ोन नंबर और प्रवेश विवरण RVM के पास रहता है। वीडियो सुरक्षित हैं और
उन्हें डाउनलोड, साझा या रिकॉर्ड नहीं किया जा सकता।

## Graphics

| Asset | Spec | Source |
| --- | --- | --- |
| App icon | 512×512 PNG, 32-bit | `mobile/assets/icon` export |
| Feature graphic | 1024×500 PNG/JPEG | RVM brand team |
| Phone screenshots | 2–8, 16:9 or 9:16, min 1080 px | Sign-in, Home, Videos, Fees, Join, Jobs |

Screenshots must show the real app, the BadaBhai Campus header only in the Jobs
web view, and no student's phone number or name.

## Data safety

Declare what the app sends today (release builds only; debug sends nothing):

| Data | Collected | Shared | Purpose | Optional |
| --- | --- | --- | --- | --- |
| Phone number | Yes | RVM Student API only | Sign-in, account, OTP | No |
| Name and admission details | Yes | RVM Student API only | Student record, receipts, certificates | No |
| ID document | Yes (upload) | RVM Student API only | Admission and verification | No |
| Attendance and class activity | Yes | RVM Student API only | Student record | No |
| Payments and receipts | Yes | RVM Student API, Razorpay | Fees and receipts | No |
| Community posts and complaints | Yes | RVM Student API only | Support and community | Yes |
| Approximate device and app diagnostics | Crashes (release only) | Firebase Crashlytics | Crash fixing | No |

- No advertising, no third-party analytics, no location, no contacts, no
  camera or microphone unless the student records a voice note.
- Crash reports carry no phone number, name, OTP or token: the app redacts
  them before sending (`core/redact/student_redact.dart`).
- Data is encrypted in transit; the session is in httpOnly cookies on web and
  secure storage on Android.

## Content rating and audience

- Target audience: 18 and over (institute students and alumni).
- No ads, no in-app purchases outside the fee the institute already bills,
  no user-to-user dating, no gambling, no violence, no mature content.
- User-generated content: the community board and complaints. Moderation and
  reporting are in the app; the profile is visible only to RVM.

## Account deletion

The public link from Scheduler_Backend#290 is the answer:
`https://student-api.rvmcad.org/student/account-deletion` (served when the
`student_web_deletion` switch is on). It must open before the listing is
submitted; the app also points to it in Profile.

## Closed testing

- Track: Closed testing (Alpha), pilot list from Prakash.
- Testers install from the Play opt-in link; no APK is handed out for Play
  testers after the first signed AAB is uploaded.
- Feedback goes to the student_app tracker; a crash in the pilot is checked
  in Crashlytics and the on-device Developer log.

## Before submitting

- [ ] #73 produced a signed AAB whose certificate is the upload key.
- [ ] `student_web_deletion` is on and the deletion link opens.
- [ ] The listing above is pasted in English and Hindi.
- [ ] The Data safety table matches the build's real requests.
- [ ] The content-rating questionnaire is complete (18+, no ads).
- [ ] The pilot tester list is uploaded.
- [ ] The first AAB is uploaded to the closed track and installed from Play.
