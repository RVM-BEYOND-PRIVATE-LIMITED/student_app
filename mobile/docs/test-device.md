# Test phone and weak-network profile

Every student-app issue is checked on the same low-cost phone and the same
weak network before it is called done (plan 8.1; student_app #1, check 8).
Students use inexpensive Android phones on patchy mobile data, so the app
must start, load and fail gracefully there, not only on a developer's phone
on office Wi-Fi.

## The test phone

**To be recorded.** No phone has been chosen yet. Fill in this table once
one is bought or assigned, and keep it the same for every later issue.

| Field | Value |
| --- | --- |
| Make and model | _to fill in_ |
| Price band | ₹10,000 to ₹15,000 (plan 8.1) |
| Android version | _to fill in_ |
| RAM / storage | _to fill in_ |
| Screen (size, resolution) | _to fill in_ |
| CPU ABI | _to fill in_ (`adb shell getprop ro.product.cpu.abi`) |
| Who holds it | _to fill in_ (a role, not a personal phone number) |

Until it is recorded, check 8 of student_app #1 stays open.

## Weak-network profile: "patchy 4G"

| Setting | Value |
| --- | --- |
| Download | 1 Mbit/s |
| Upload | 256 kbit/s |
| Round-trip delay | 300 ms, varying by ±100 ms |
| Packet loss | 2 % |
| Drop-outs | The connection goes away for 10 seconds, then comes back, at least once per test run |

### How to apply it

Laptop hotspot (Linux), the phone on the laptop's Wi-Fi; `wlan0` is the
interface the phone connects through:

```bash
# On
sudo tc qdisc add dev wlan0 root netem \
  delay 300ms 100ms distribution normal loss 2% rate 1mbit
# Off
sudo tc qdisc del dev wlan0 root
```

`tc netem` shapes the traffic the laptop sends to the phone, the download
side. The upload limit needs the same rule on the laptop's upstream
interface or an IFB device; if that is not set up, write so in the test
notes.

Android emulator (a stand-in only, never a replacement for the phone):

```bash
emulator -avd <name> -netdelay 200:400 -netspeed 256:1024
```

Drop-outs: switch on aeroplane mode for 10 seconds, then switch it off.

## What to check, every issue

- Cold start from a killed app: time from the launcher tap to the first
  usable screen.
- Each shared state appears where it should: the skeleton while loading,
  the empty state, the error with "Try again" and its request id, and the
  offline banner during a drop-out (it goes away when the network returns).
- A retry after a drop-out completes, and a repeated form does not create a
  second record (the Idempotency-Key).
- The same checks in Hindi: nothing clipped, nothing in English.
- Record the phone, the app version and the result in the pull request.
