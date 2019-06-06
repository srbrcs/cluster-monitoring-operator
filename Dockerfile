FROM openshift/origin-base:v3.11

ENV GOPATH /go
ENV PATH="${PATH}:${GOPATH}/bin"
RUN mkdir $GOPATH

COPY . $GOPATH/src/github.com/openshift/cluster-monitoring-operator

RUN yum install epel-release -y
RUN yum install -y golang make git jq
RUN cd $GOPATH/src/github.com/openshift/cluster-monitoring-operator && make dependencies pkg/manifests/bindata.go operator-no-deps 
RUN cp $GOPATH/src/github.com/openshift/cluster-monitoring-operator/operator /usr/bin/  # && \ # yum autoremove -y golang make git && yum clean all

LABEL io.k8s.display-name="OpenShift cluster-monitoring-operator" \
      io.k8s.description="This is a component of OpenShift Container Platform and manages the lifecycle of the Prometheus based cluster monitoring stack." \
      io.openshift.tags="openshift" \
      maintainer="Frederic Branczyk <fbranczy@redhat.com>"

# doesn't require a root user.
USER 1001

ENTRYPOINT ["/usr/bin/operator"]
