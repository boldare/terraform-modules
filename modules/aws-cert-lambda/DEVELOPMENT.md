# Development

If you modified `requirements.txt` contents, please update layer zip file, which has to be built using an actual Amazon Linux 2:

```bash
cd src
packer build requirements.json
```
