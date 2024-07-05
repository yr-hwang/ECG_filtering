# Filtering of ECG Signal
The purpose of this project is to remove the noise from the ECG signal through filtering in the frequency domain and remove sinusoidal interference from a corrupted ECG signal to produce a clean signal.

Electrocardiography (ECG) refers to the potential difference between consecutive heartbeats as the heart contracts and occurs in wavelengths. 

![image](https://github.com/yr-hwang/ECG_filtering/assets/173549924/5eda1eae-786c-4ea5-89ed-48345dcd375a)

Standard lead is a method to record ECG by connecting an electrode to the right hand, left hand, and left foot. The signal of lead II is used in this project as the P wave of the signal can be observed easily due to the direction of induction coinciding with the axial direction of the largest cross-section of the heart.

## Filtering in the Frequency Domain
The lead II signal was loaded and a sampling frequency of 500Hz was chosen. A 16-point averaging filter with and without zero-padding was applied to the signal and was compared. Zero-padding increases the length of the signal and provides a smoother transition between samples by interpolation. The comparison can be observed in the figure below.

![Untitled](https://github.com/yr-hwang/ECG_filtering/assets/173549924/bfcc1faf-f80b-4281-bab4-105f60fd01bb)

Then, an ideal LPF, HPF, and BPF were applied to the DFT of the signal. It can be observed tht the LPF  was able to remove the high frequency noise of the signal, the HPF was able to lower the baseline of the of the signal, and the BPF was able to preserve the functions of both the LPF and BPF. The comparison of the three filters are as below.

![untitled2](https://github.com/yr-hwang/ECG_filtering/assets/173549924/2df8be67-0fbd-4624-b11a-db585506ffbd)

## Removing Sinusoidal Interference

When recording the standard lead signal, often the electrodes pick up signals from other electrical sources as well. Most notably, harmonics of the 60-Hz power signal are often picked up, which can be observed in the figure below. The noise frequency appears as an abrupt spike in the magnitude plot.

![untitled7](https://github.com/yr-hwang/ECG_filtering/assets/173549924/46fec80a-a74a-4c29-b857-3855a73004fc)

![untitled3](https://github.com/yr-hwang/ECG_filtering/assets/173549924/03477273-7531-455c-aa7d-827e3bbe023c)

To remove this frequency, an IIR notch filter is designed by choosing the appropriate values for *r* in the system function, and it is then applied to the signal. 

![image](https://github.com/yr-hwang/ECG_filtering/assets/173549924/7c929581-21ce-4314-b46a-939c35e60166)

![untitled4](https://github.com/yr-hwang/ECG_filtering/assets/173549924/eab08418-b8db-4cec-bf69-9c1d8995b36b)

The filtered output of lead II was plotted in both the time and frequency domain respectively.

![untitled5](https://github.com/yr-hwang/ECG_filtering/assets/173549924/65225498-be03-4979-81b5-f4d0297caec3)

![untitled6](https://github.com/yr-hwang/ECG_filtering/assets/173549924/20410fe8-9d47-4095-b3c5-a068f135a73f)

A comparison of how the different *r* values can affect the filtered output can be seen in the below figure.

![untitled8](https://github.com/yr-hwang/ECG_filtering/assets/173549924/bd90bbd7-dfe1-488e-94c4-eac63e6d1b99)

It can be deduced that an r value within the range of 0.95 to 0.99 produces the best results.
