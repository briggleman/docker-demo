MAINTAINER Ben Riggleman
# use a pre-built version of python
# debian jessie, slimmed down with only the essentials
FROM python:3.6.2-slim

# expose port 8080, this is how docker knows to map traffic to our container
EXPOSE 8080

# set our home directory to app
ENV DEMO_HOME /app
# add our home path to the system path so we can cd $DEMO_HOME
ENV PATH $DEMO_HOME:$PATH

# set our working directory to $DEMO_HOME i.e. /app
WORKDIR $DEMO_HOME

# install any requirements we have that may not change often
# this is done for docker caching purposes so we don't always rebuild this layer
RUN apt-get update && \
    apt-get install -y gcc

# copy the required files only
COPY runserver.py $DEMO_HOME/runserver.py
COPY requirements.txt $DEMO_HOME/requirements.txt
COPY demo/ $DEMO_HOME/demo

# install our python pip requirements, these may change so we'll always rebuild them
RUN pip install --no-cache-dir -r requirements.txt && \
    rm -f requirements.txt

# tell docker to run this command when we start our image
CMD ["python", "runserver.py", "-H", "0.0.0.0"]