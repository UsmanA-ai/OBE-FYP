# pip install flask flask-cors pymupdf python-docx sentence-transformers textstat scikit-learn
# pip install flask flask-cors pymupdf python-docx sentence-transformers textstat scikit-learn --dev
# pipenv shell
# python3 app.py

import os
import tempfile
import re
from flask_cors import CORS

from flask import Flask, request, jsonify
import fitz  # PyMuPDF for PDFs
from docx import Document  # For .docx files
from sentence_transformers import SentenceTransformer, util
from textstat import flesch_reading_ease
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.decomposition import LatentDirichletAllocation
from sklearn.feature_extraction.text import CountVectorizer

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})
model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")  # Free relevance model

ALLOWED_EXTENSIONS = {".pdf", ".txt", ".docx"}
RELEVANCY_THRESHOLD = 20  # Below 20% is considered irrelevant


@app.route("/upload", methods=["POST"])

def upload_file():
    if 'file' not in request.files or 'question' not in request.form or 'totalMarks' not in request.form:
        return jsonify({"error": "Missing required fields"}), 400
    
    file = request.files['file']
    question = request.form['question']
    total_marks = float(request.form['totalMarks'])
    print(file, "--------------file")
    print(question, "--------------question")
    print(total_marks, "--------------total_marks")
    if file.filename == '':
        return jsonify({"error": "No file found"}), 400
    
    ext = os.path.splitext(file.filename)[1].lower()
    if ext not in ALLOWED_EXTENSIONS:
        return jsonify({"error": "Wrong file extension uploaded"}), 400
    
    with tempfile.NamedTemporaryFile(delete=False, suffix=ext) as temp_file:
        file.save(temp_file.name)
        temp_path = temp_file.name
    
    text = extract_text_from_file(temp_path)
    os.unlink(temp_path)
    
    if text is None:
        return jsonify({"final_grade": "F", "plagiarism_score": 0, "relevancy_score": 0, "readability_score": 0, "assignment_marks": 0}), 200
    
    cleaned_text = preprocess_text(text)
    if not is_valid_file(cleaned_text):
        return jsonify({"final_grade": "F", "assignment_marks": 0}), 200
    
    plagiarism_score = check_plagiarism(cleaned_text)
    relevancy_score = check_relevancy(cleaned_text, question)
    readability_score = flesch_reading_ease(cleaned_text)
    final_grade, assignment_marks = compute_grade(plagiarism_score, relevancy_score, readability_score, total_marks)
    gpa = compute_gpa(plagiarism_score, relevancy_score, readability_score)
    
    return jsonify({
        "plagiarism_score": plagiarism_score,
        "relevancy_score": relevancy_score,
        "readability_score": readability_score,
        "final_grade": final_grade,
        "gpa": gpa,
        "assignment_marks": assignment_marks
    })

def extract_text_from_file(file_path):
    ext = os.path.splitext(file_path)[1].lower()
    if ext == ".pdf":
        doc = fitz.open(file_path)
        return "\n".join([page.get_text() for page in doc])
    elif ext == ".txt":
        with open(file_path, "r", encoding="utf-8") as f:
            return f.read()
    elif ext == ".docx":
        doc = Document(file_path)
        return "\n".join([para.text for para in doc.paragraphs])
    return None  # Unsupported format

def preprocess_text(text):
    text = re.sub(r'\[.*?\]', '', text)
    text = re.sub(r'\b(?:References|Bibliography)\b.*', '', text, flags=re.DOTALL)
    text = re.sub(r'\b(?:Appendix|Acknowledgments)\b.*', '', text, flags=re.DOTALL)
    text = re.sub(r'\d{1,3}\.\d{1,3}', '', text)
    text = re.sub(r'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+', '', text)
    return text

def is_valid_file(text):
    if len(text.split()) < 50:
        return False
    if re.search(r"(this\s?document\s?is\s?irrelevant|random\s?data)", text, re.I):
        return False
    return True

def topic_modeling(texts):
    vectorizer = CountVectorizer(stop_words='english')
    X = vectorizer.fit_transform(texts)
    lda = LatentDirichletAllocation(n_components=5, random_state=42)
    lda.fit(X)
    return lda.components_

def check_plagiarism(text):
    corpus = ["This is an example reference document.", "Another academic source for plagiarism check."]
    corpus.append(text)
    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform(corpus)
    similarity_scores = cosine_similarity(tfidf_matrix[-1], tfidf_matrix[:-1])
    max_score = max(similarity_scores[0]) * 100
    return 100 - max_score

def check_relevancy(text, question):
    cleaned_text = preprocess_text(text)
    assignment_embedding = model.encode(cleaned_text, convert_to_tensor=True)
    question_embedding = model.encode(question, convert_to_tensor=True)
    similarity = util.pytorch_cos_sim(assignment_embedding, question_embedding).item()
    return similarity * 100

def compute_grade(plagiarism, relevancy, readability, total_marks):
    if relevancy < RELEVANCY_THRESHOLD:
        return "F", 0
    weighted_score = (0.4 * plagiarism) + (0.4 * relevancy) + (0.2 * readability)
    marks_obtained = (weighted_score / 100) * total_marks
    if weighted_score >= 90:
        return "A+", marks_obtained
    elif weighted_score >= 80:
        return "A", marks_obtained
    elif weighted_score >= 75:
        return "B+", marks_obtained
    elif weighted_score >= 70:
        return "B", marks_obtained
    elif weighted_score >= 65:
        return "C+", marks_obtained
    elif weighted_score >= 60:
        return "C", marks_obtained
    else:
        return "F", marks_obtained

def compute_gpa(plagiarism, relevancy, readability):
    if relevancy < RELEVANCY_THRESHOLD:
        return "0.00"
    weighted_score = (0.4 * plagiarism) + (0.4 * relevancy) + (0.2 * readability)
    if weighted_score >= 90:
        return "4.00"
    elif weighted_score >= 80:
        return "4.00"
    elif weighted_score >= 75:
        return "3.50"
    elif weighted_score >= 70:
        return "3.00"
    elif weighted_score >= 65:
        return "2.50"
    elif weighted_score >= 60:
        return "2.00"
    else:
        return "0.00"

if __name__ == "__main__":
    app.run(debug=True)
