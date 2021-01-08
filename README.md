# aws_workspaces_env
簡単なAmazon WorkSpaces環境を組む

## できるもの

AWSアカウント上に以下を作成する

- VPC
    - Public Subnet x 2
    - Private Subnet x 2
    - Route Table (for Public, for Private)
- EC2インスタンス (Windows)
    - 特定IPからRDPアクセスを許可
    - Public Subnetに配置
- AWS Directory Service
    - Simple AD (Small)
- Amazon Workspaces
    - ディレクトリ設定
    - WorkSpace

## ディレクトリ構成

aws_terraform/common ディレクトリに共通のファイルを置いて、各ディレクトリにシンボリックリンクを張っている。

```
./aws_terraform/
├── ad_wsdir
│   ├── aws_ad.tf
│   ├── aws_ec2.tf
│   ├── aws_iam.tf
│   ├── aws_sg.tf
│   ├── aws_vpc_module.tf
│   ├── aws_workspaces_dir.tf
│   ├── output.tf
│   ├── terraform.tf -> ../common/terraform.tf
│   ├── terraform.tfstate
│   ├── terraform.tfvars -> ../common/terraform.tfvars
│   ├── variables.tf
│   └── versions.tf -> ../common/versions.tf
├── common
│   ├── terraform.tf
│   ├── terraform.tfvars
│   └── versions.tf
└── workspaces
    ├── aws_workspaces.tf
    ├── terraform.tf -> ../common/terraform.tf
    ├── terraform.tfvars -> ../common/terraform.tfvars
    ├── variables.tf
    └── versions.tf -> ../common/versions.tf
```

## 準備

Terraformでのデプロイにあたって、以下の準備を行う

### SSHキーペアの作成

EC2インスタンスにアクセスするためのキーペアを作成する (Windowsインスタンスのパスワードを展開する際にOPENSSHフォーマットだと失敗するので、 `-m PEM` オプションをつけてPEMで作成する。
)

```
$ ssh-keygen -t rsa -b 4096 -m PEM
```

コンソールでEnterし続けると `~/.ssh/id_rsa`, `~/.ssh/id_rsa.pub` が作成されるので適宜リネームする

```
$ mkdir -p ~/.ssh/keys
$ mv ~/.ssh/id_rsa ~/.ssh/keys/test
$ mv ~/.ssh/id_rsa.pub ~/.ssh/keys/test.pub
```

### クレデンシャル情報を設定

環境変数を設定する。(`AWS_PROFILE` 設定を推奨)

```
### アクセスキーを直接指定する場合 (非推奨)
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=xxx

### 名前付きプロファイルを指定する場合 (推奨)
export AWS_PROFILE="my-profile"

### 名前付きプロファイルでIAMロールを利用する場合、以下を追加する
export AWS_SDK_LOAD_CONFIG=1
```

### terraform.tfvars の作成

`aws_terraform/common/terraform.tfvars` に個別の変数を埋め込む。以下の `$HOME` はユーザーのホームディレクトリに適宜書き換える (変数展開ができなかったため)

```
public_key_path="$HOME/.ssh/keys/test.pub"
my_ip="x.x.x.x/32"
ad_admin_password="ad-test1234"
ad_domain_name="test.manabu-yazawa.com"
```

各項目に以下要領で値を入れる

| 項目 | 内容 |
| ------ | ------ |
| public_key_path | 公開鍵ファイルのパス |
| my_ip | SSHの接続元IP |
| ad_admin_password | ADの管理者パスワード |
| ad_domain_name | ADのドメイン名 |

## デプロイ

aws_terraform/ad_wsr, aws_terraform/workspaces ディレクトリで以下コマンドを実行し、構成を確認する。

```
$ terraform init #初回のみ
$ terraform plan
```

以下コマンドで構成をAWS環境にデプロイする。

```
$ terraform apply
```

EC2インスタンスにRDP接続する (コンソールからPassを取得する際にSSH秘密鍵を使う)