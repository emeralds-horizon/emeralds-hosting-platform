# Access Services on different Namespaces
Since the Ingress configuration is located in ArgoCD namespace and the Emeralds are deployed on the default namespace an additional service is required for each emerald in the argoCD namespace. 
https://stackoverflow.com/questions/59844622/ingress-configuration-for-k8s-in-different-namespaces
