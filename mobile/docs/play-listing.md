# Play listing pack (student_app #8, item 10)

Prepared from the student app's screens. Screenshots and the feature graphic
need the test phone; the store tax forms and the final publish are Prakash's
(student_app #20). The privacy policy and account-deletion pages must cover
this app; the current website pages are for another RVM app
(rvm-cad-website#12).

## Name and short description

- **App name:** RVM Student
- **Short description (en):** Fees, classes and jobs for RVM students.
- **Short description (hi):** RVM छात्रों के लिए फ़ीस, क्लास और नौकरियाँ।

## Full description

**English**

> RVM Student is the app for students at RVM CAD centres.
>
> Sign in with your mobile number to see your admission, fee plan and
> receipts, your timetable and attendance, announcements and your classes.
> Joined students can open BadaBhai Campus inside the app to browse jobs and
> apply, already signed in.
>
> The app shows what RVM's records say. Nothing is paid to the app, and no
> job is sold. Your data stays with RVM and the services named in the privacy
> policy.

**Hindi**

> RVM Student, RVM CAD सेंटरों के छात्रों के लिए ऐप है।
>
> अपने मोबाइल नंबर से साइन इन करके अपनी एडमिशन, फ़ीस योजना और रसीदें, समय-सारिणी
> और उपस्थिति, सूचनाएँ और अपनी क्लास देखें। जुड़े हुए छात्र ऐप के अंदर बड़ाभाई
> कैंपस खोलकर नौकरियाँ देख सकते हैं और आवेदन कर सकते हैं, पहले से साइन इन।
>
> ऐप वही दिखाता है जो RVM के रिकॉर्ड में है। ऐप को कोई भुगतान नहीं किया जाता और
> कोई नौकरी बेची नहीं जाती। आपका डेटा RVM और गोपनीयता नीति में बताई सेवाओं के पास
> रहता है।

## Category and contact

- Category: Education
- Contact: the centre's public number from `/v1/branches` (not written here;
  it changes on the server)
- Website: the RVM website

## Data safety answers

| Data | Collected | Shared | Purpose | Notes |
|---|---|---|---|---|
| Phone number | Yes | With Campus only for jobs | Account, support | Own number, masked in the app |
| Name, email | Yes | With Campus only for jobs | Admission, applications | Entered at joining |
| ID document image | Yes (joining) | No | Admission verification | Uploaded to the Student API |
| Payout account (UPI/bank) | Yes (placement proof) | With the payout provider only | Paying a placement reward | Masked after saving |
| Payments | Yes | With Razorpay | Course fees | No card data in the app |
| Device identifiers | Yes (install id) | No | One bound phone, security | Reset on reinstall |
| Crash data | Yes (on phone now) | No | Fixing crashes | Cleaned of personal data |
| Approximate location | No | — | — | No location permission |
| Contacts, photos, files | File the student picks only | No | Résumé and ID upload | System picker; no broad storage permission |

- Data is encrypted in transit (HTTPS).
- Account deletion: request in Profile (#4) and a web page (rvm-cad-website#12).
- No advertising SDK and no tracker.

## Permissions

- `android.permission.INTERNET` only. Calls (`tel:`) and external links use
  intents, no `CALL_PHONE`. File uploads use the system picker, no broad
  storage permission. No location, contacts or camera permission is
  requested.

## Content rating

- No user-generated content shown to the public, no ads, no gambling, no
  violence. Community posts (#5) are limited to signed-in students and are
  moderated.

## Payments policy (check before the first submission)

Google treats in-person training and digital content differently. Course
fees for training at a centre are a service; online-only or recorded-video
access may count as digital content. Read the current Play payments policy
before submitting and take the result to Akshit if it changes how fees are
collected (student_app #8, private notes). No digital purchase is built in
the app for iPhone; there is no iPhone app.

## Assets still needed

- [ ] Phone screenshots (English and Hindi) from the test phone.
- [ ] Feature graphic and icon (the launcher icon exists).
- [ ] Privacy policy and data-deletion URLs that name this app.
- [ ] The data-safety form filled in Play Console (Prakash).

## Tracks (item 11)

- Internal, then closed testing with the pilot list, then production with a
  staged rollout. Version numbers follow the minimum-version gate. Start
  this as soon as Play approves the account; it does not wait for #8's other
  items.
