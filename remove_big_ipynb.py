import os

threshold = 5 * 1024 * 1024

def blob_callback(blob, metadata):
    if not blob.path.endswith(b'.ipynb'):
        return
    if len(blob.data) <= threshold:
        return
    blob.skip()
