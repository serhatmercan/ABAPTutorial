* TEXT-001 TEXT-002 gibi metin öğeleriyle bir cümle oluşturalan program 
* Program; kullanicinin login olduğu dile göre türkçe ve ingilizce destekliyor olsun.

DATA : message(13).

CONCATENATE text-001 text-002 '' INTO message SEPARATED BY space.

WRITE: message.
