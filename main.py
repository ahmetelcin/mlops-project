from fastapi import FastAPI, File, UploadFile
from tensorflow.keras.models import load_model
import numpy as np
from PIL import Image
import io

app = FastAPI(title="Kedi & Köpek Sınıflandırma API")

model_path = "kedi_kopek_modeli.h5"

model = load_model(model_path)

@app.post("/predict", tags=["Predictions"])
async def predict(file: UploadFile = File(...)):
    """
    Bu fonksiyon, bir resim dosyası alıp tahmin yapar.
    """

    contents = await file.read()

    image = Image.open(io.BytesIO(contents))

    image = image.convert("RGB")

    image = image.resize((180, 180))

    image_array = np.array(image)

    image_array = np.expand_dims(image_array, axis=0)

    predictions = model.predict(image_array)

    score = predictions[0][0]

    if score < 0.5:
        result = "Cat"
        confidence = 1 - score
    else:
        result = "Dog"
        confidence = score

    return {
        "filename": file.filename,
        "prediction": result,
        "confidence": float(confidence)
    }