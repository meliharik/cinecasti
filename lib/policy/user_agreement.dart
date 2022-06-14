import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/helper/height_width.dart';
import 'package:flutter/material.dart';

class KullanimKosullari extends StatelessWidget {
  const KullanimKosullari({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                FontAwesomeIcons.chevronLeft,
                // color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text('user_agreement'.tr().toString()),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          boslukHeight(context, 0.01),
          Row(
            children: [
              boslukWidth(context, 0.03),
              Text(
                'Kullanım Koşulları',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                  // color: const Color(0xff252745),
                ),
              ),
              boslukWidth(context, 0.03),
            ],
          ),
          boslukHeight(context, 0.01),
          Row(
            children: [
              boslukWidth(context, 0.03),
              Expanded(
                child: Text(
                  '  - Sevgili kullanıcımız, lütfen cinecasti uygulamamıza kayıt olmadan önce işbu kullanım koşulları sözleşmesini dikkatlice okuyunuz. Uygulamaya erişiminiz tamamen bu sözleşmeyi kabulünüze ve bu sözleşme ile belirlenen şartlara uymanıza bağlıdır. Şayet bu sözleşmede yazan herhangi bir koşulu kabul etmiyorsanız, lütfen uygulamaya erişiminizi sonlandırınız. Uygulamaya erişiminizi sürdürdüğünüz takdirde, koşulsuz ve kısıtlamasız olarak, işbu sözleşme metninin tamamını kabul ettiğinizin, tarafımızca varsayılacağını lütfen unutmayınız.\n  - Değişiklik yapma hakkı, tek taraflı olarak cinecasti\'a aittir ve cinecasti üzerinden güncel olarak paylaşılacak olan bu değişiklikleri, tüm kullanıcılarımız baştan kabul etmiş sayılır.',
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.height * 0.017,
                    // color: const Color(0xff252745),
                  ),
                ),
              ),
              boslukWidth(context, 0.03),
            ],
          ),
          boslukHeight(context, 0.03),
          Row(
            children: [
              boslukWidth(context, 0.03),
              Expanded(
                child: Text(
                  'Gizlilik',
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    // color: const Color(0xff252745),
                  ),
                ),
              ),
              boslukWidth(context, 0.03),
            ],
          ),
          boslukHeight(context, 0.01),
          Row(
            children: [
              boslukWidth(context, 0.03),
              Expanded(
                child: Text(
                  '  - Gizlilik, ayrı bir sayfada, kişisel verilerinizin tarafımızca işlenmesinin esaslarını düzenlemek üzere mevcuttur. cinecasti\'i kullandığınız takdirde, bu verilerin işlenmesinin gizlilik politikasına uygun olarak gerçekleştiğini kabul edersiniz.',
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.height * 0.017,
                    // color: const Color(0xff252745),
                  ),
                ),
              ),
              boslukWidth(context, 0.03),
            ],
          ),
          boslukHeight(context, 0.03),
          Row(
            children: [
              boslukWidth(context, 0.03),
              Expanded(
                child: Text(
                  'Hizmet Kapsamı',
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    // color: const Color(0xff252745),
                  ),
                ),
              ),
              boslukWidth(context, 0.03),
            ],
          ),
          boslukHeight(context, 0.01),
          Row(
            children: [
              boslukWidth(context, 0.03),
              Expanded(
                child: Text(
                  '  - cinecasti olarak, sunacağımız hizmetlerin kapsamını ve niteliğini, yasalar çerçevesinde belirlemekte tamamen serbest olup; hizmetlere ilişkin yapacağımız değişiklikler, cinecasti\'da yayınlanmakla yürürlüğe girmiş sayılacaktır.',
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.height * 0.017,
                    // color: const Color(0xff252745),
                  ),
                ),
              ),
              boslukWidth(context, 0.03),
            ],
          ),
          boslukHeight(context, 0.03),
          Row(
            children: [
              boslukWidth(context, 0.03),
              Expanded(
                child: Text(
                  'Telif Hakları',
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    // color: const Color(0xff252745),
                  ),
                ),
              ),
              boslukWidth(context, 0.03),
            ],
          ),
          boslukHeight(context, 0.01),
          Row(
            children: [
              boslukWidth(context, 0.03),
              Expanded(
                child: Text(
                  '  - cinecasti\'da yayınlanan tüm metin, kod, grafikler, logolar, resimler, ses dosyaları ve kullanılan yazılımın sahibi (bundan böyle ve daha sonra "içerik" olarak anılacaktır) cinecasti olup, tüm hakları saklıdır. Yazılı izin olmaksızın site içeriğinin çoğaltılması veya kopyalanması kesinlikle yasaktır.',
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.height * 0.017,
                    // color: const Color(0xff252745),
                  ),
                ),
              ),
              boslukWidth(context, 0.03),
            ],
          ),
          boslukHeight(context, 0.03),
          Row(
            children: [
              boslukWidth(context, 0.03),
              Expanded(
                child: Text(
                  'Genel Hükümler',
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    // color: const Color(0xff252745),
                  ),
                ),
              ),
              boslukWidth(context, 0.03),
            ],
          ),
          boslukHeight(context, 0.01),
          Row(
            children: [
              boslukWidth(context, 0.03),
              Expanded(
                child: Text(
                  ' - Kullanıcıların tamamı, cinecasti\'ı yalnızca hukuka uygun ve şahsi amaçlarla kullanacaklarını ve üçüncü kişinin haklarına tecavüz teşkil edecek nitelikteki herhangi bir faaliyette bulunmayacağını taahhüt eder. cinecasti dâhilinde yaptıkları işlem ve eylemlerindeki, hukuki ve cezai sorumlulukları kendilerine aittir. İşbu iş ve eylemler sebebiyle, üçüncü kişilerin uğradıkları veya uğrayabilecekleri zararlardan dolayı cinecasti\'ın doğrudan ve/veya dolaylı hiçbir sorumluluğu yoktur.\n  - cinecasti\'da mevcut bilgilerin doğruluk ve güncelliğini sağlamak için elimizden geleni yapmaktayız. Lakin gösterdiğimiz çabaya rağmen, bu bilgiler, fiili değişikliklerin gerisinde kalabilir, birtakım farklılıklar olabilir. Bu sebeple, site içerisinde yer alan bilgilerin doğruluğu ve güncelliği ile ilgili tarafımızca, açık veya zımni, herhangi bir garanti verilmemekte, hiçbir taahhütte bulunulmamaktadır.\n  - cinecasti\'da üçüncü şahıslar tarafından işletilen ve içerikleri tarafımızca bilinmeyen diğer web sitelerine, uygulamalara ve platformlara köprüler (hyperlink) bulunabilir. cinecasti, işlevsellik yalnızca bu sitelere ulaşımı sağlamakta olup, içerikleri ile ilgili hiçbir sorumluluk kabul etmemekteyiz.\n  - cinecasti\'ı virüslerden temizlenmiş tutmak konusunda elimizden geleni yapsak da, virüslerin tamamen bulunmadığı garantisini vermemekteyiz. Bu nedenle veri indirirken, virüslere karşı gerekli önlemi almak, kullanıcıların sorumluluğundadır. Virüs vb. kötü amaçlı programlar, kodlar veya materyallerin sebep olabileceği zararlardan dolayı sorumluluk kabul etmemekteyiz.\n  - cinecasti\'da sunulan hizmetlerde, kusur veya hata olmayacağına ya da kesintisiz hizmet verileceğine dair garanti vermemekteyiz. cinecasti\'a ve sitenin hizmetlerine veya herhangi bir bölümüne olan erişiminizi önceden bildirmeksizin herhangi bir zamanda sonlandırabiliriz.',
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.height * 0.017,
                    // color: const Color(0xff252745),
                  ),
                ),
              ),
              boslukWidth(context, 0.03),
            ],
          ),
          boslukHeight(context, 0.03),
          Row(
            children: [
              boslukWidth(context, 0.03),
              Expanded(
                child: Text(
                  'Sorumluluğun Sınırlandırılması',
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    // color: const Color(0xff252745),
                  ),
                ),
              ),
              boslukWidth(context, 0.03),
            ],
          ),
          boslukHeight(context, 0.01),
          Row(
            children: [
              boslukWidth(context, 0.03),
              Expanded(
                child: Text(
                  '  - cinecasti\'ın kullanımından doğan zararlara ilişkin sorumluluğumuz, kast ve ağır ihmal ile sınırlıdır. Sözleşmenin ihlalinden doğan zararlarda, talep edilebilecek toplam tazminat, öngörülebilir hasarlar ile sınırlıdır. Yukarıda bahsedilen sorumluluk sınırlamaları aynı zamanda insan hayatına, bedeni yaralanmaya veya bir kişinin sağlığına gelebilecek zararlar durumunda geçerli değildir. Hukuken mücbir sebep sayılan tüm durumlarda, gecikme, ifa etmeme veya temerrütten dolayı, herhangi bir tazminat yükümlülüğümüz doğmayacaktır.\nUyuşmazlık Çözümü: İşbu Sözleşme\'nin uygulanmasından veya yorumlanmasından doğacak her türlü uyuşmazlığın çözümünde, Türkiye Cumhuriyeti yasaları uygulanır; Yozgat Adliyesi Mahkemeleri ve İcra Daireleri yetkilidir.',
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.height * 0.017,
                    // color: const Color(0xff252745),
                  ),
                ),
              ),
              boslukWidth(context, 0.03),
            ],
          ),
          boslukHeight(context, 0.1),
        ],
      )),
    );
  }
}
