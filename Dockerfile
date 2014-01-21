FROM ubuntu
MAINTAINER Matthew Schulkind <matt@fogengine.com>

RUN apt-get update
RUN apt-get install -y python-setuptools build-essential libpq-dev postgresql-client-9.1 python-dev expect
RUN easy_install -UZ virtualenv
RUN virtualenv /www/sentry
RUN /bin/bash -c 'source /www/sentry/bin/activate && easy_install -UZ psycopg2'
ADD sentry.conf.py /etc/sentry.conf.py
ADD sentry/ /root/sentry
ADD create_sentry_user /www/sentry/bin/create_sentry_user
RUN /bin/bash -c 'source /www/sentry/bin/activate && cd /root/sentry && python setup.py install'
RUN rm -rf /root/sentry

CMD /bin/bash -c 'source /www/sentry/bin/activate && sentry --config=/etc/sentry.conf.py start'
