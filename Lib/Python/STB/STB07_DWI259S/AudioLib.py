from audioverification import get_average_rms

def get_rms_value(device="hw:1,0", silence_threshold=0.005):
    """Return RMS and activity flag."""
    rms = get_average_rms(device=device)
    active = rms > silence_threshold
    return rms, active
