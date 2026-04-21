variable "region" {
  type        = string
  description = "Región de AWS donde se desplegará la infraestructura"
}

variable "vpc_cidr" {
  type        = string
  description = "Bloque CIDR para la VPC"
}

variable "subnet_cidr" {
  type        = string
  description = "Bloque CIDR para la Subnet"
}

variable "az" {
  type        = string
  description = "Zona de disponibilidad para la Subnet"
}

variable "ami_id" {
  type        = string
  description = "ID de la AMI para la instancia"
}

variable "instance_type" {
  type        = string
  description = "Tipo de instancia de EC2"
}

variable "key_name" {
  type        = string
  description = "Nombre de la llave para acceder a la instancia"
}
