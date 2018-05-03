VERSION ?= 0.2.1
IMAGE_NAME ?= fluentd-splunk-hec
# TARGET_NAME ?= gimil/${IMAGE_NAME}:${VERSION}
TARGET_NAME ?= gimil/k8s-l:${VERSION}

docker: Dockerfile
	docker build -t $(IMAGE_NAME):$(VERSION) .
	docker tag $(IMAGE_NAME):$(VERSION) $(TARGET_NAME)

push:
	docker push $(TARGET_NAME)
