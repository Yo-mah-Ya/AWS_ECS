FROM python:3.7
#build settings
RUN mkdir /Fargate
ADD app /Fargate
RUN pip install boto3 flask gunicorn
#run settings
WORKDIR /Fargate
EXPOSE 3000
CMD ["gunicorn","app:app","-c","gunicorn_settings.py"]
