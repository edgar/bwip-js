How to test the chart:

```
brew install kubernetes-helm

# in the project root:
export CHART_VERSION=0.0.1 && \
export APP_VERSION=${CHART_VERSION}-3196cc4.1 && \
export APP_NAME=bwip-js && \

helm repo update
helm dependency update helm/${APP_NAME}
rm -f helm/packages/${APP_NAME}-${CHART_VERSION}-test-render.yaml \
&& helm package --version=${CHART_VERSION} --app-version=${APP_VERSION} helm/${APP_NAME} -d helm/packages/ \
  && helm lint --set-string="ciLabels.appVersion=${APP_VERSION}" helm/packages/${APP_NAME}-${CHART_VERSION}.tgz \
  && helm template helm/packages/${APP_NAME}-${CHART_VERSION}.tgz -f \
    helm/${APP_NAME}/values.test.yaml > helm/packages/${APP_NAME}-${CHART_VERSION}-test-render.yaml \
  && echo helm/packages/${APP_NAME}-${CHART_VERSION}-test-render.yaml \
  && yamllint -d "{rules: {line-length: {max: 120}}}" helm/packages/${APP_NAME}-${CHART_VERSION}-test-render.yaml

# CAREFUL! Check kubectl context before applying the following commands:
helm install --debug --dry-run helm/packages/${APP_NAME}-${CHART_VERSION}.tgz -f helm/${APP_NAME}/values.test.yaml
kubectl apply -n dryruns --dry-run -f helm/packages/${APP_NAME}-${CHART_VERSION}-test-render.yaml
```

> A hint:
> IntelliJ IDEA with the latest versions of the plugins:
> 
>  - `Kubernetes`,
>  - `Go`
>  - and `Go Templates` 
>  
> ...will show you wrong YAML indentation for Helm packages and Kubernetes configuration.
