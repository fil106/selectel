## Пример подключения sfs к k8s

```sh
.
├── pod-sfs-test.yaml
├── pod.yaml
├── service
│   └── service-nginx.yaml
└── storage
    ├── pv.yaml
    └── pvc.yaml

3 directories, 5 files
```

Данный пример показывает как создать pv→pvc→deployment/pod→service
