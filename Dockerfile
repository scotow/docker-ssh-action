FROM docker:stable

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]