#!/bin/bash
kubectl get secret argocd-secret -n argocd -o jsonpath='{.data.tls\.key}' | base64 --decode > server.key
kubectl get secret argocd-secret -n argocd -o jsonpath='{.data.tls\.crt}' | base64 --decode > server.crt