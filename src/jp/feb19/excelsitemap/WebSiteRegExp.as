package jp.feb19.excelsitemap
{
	public class WebSiteRegExp
	{
		public static const TITLE:RegExp			= new RegExp('<title>.*?</title>', "ig");
		public static const TITLE_CONTENT:RegExp	= new RegExp("<(\"[^\"]*\"|'[^']*'|[^'\">])*>", "gim");
		
		public static const META_CONTENT:RegExp		= new RegExp("((?:src|href|content)=(?:\"|'))(.*?)(.*?)(\"|')", "gim");
		
		public static const DESCRIPTION:RegExp		= new RegExp("<meta[^>]+name=['\"]+description.+['\"]?+content=['\"](.*?)['\"]", "igm");
		public static const KEYWORDS:RegExp			= new RegExp("<meta[^>]+name=['\"]+keywords.+['\"]?+content=['\"](.*?)['\"]", "igm");
		
		public static const PROPERTIES:RegExp		= new RegExp("<meta[^>]+property=['\"]?(.*?)['\"]?+content=['\"](.*?)['\"]", "igm");
		public static const OG_TITLE:RegExp			= new RegExp("<meta[^>]+property=['\"]+og:title.+['\"]?+content=['\"](.*?)['\"]", "igm");
		public static const OG_TYPE:RegExp			= new RegExp("<meta[^>]+property=['\"]+og:type.+['\"]?+content=['\"](.*?)['\"]", "igm");
		public static const OG_DESCRIPTION:RegExp	= new RegExp("<meta[^>]+property=['\"]+og:description.+['\"]?+content=['\"](.*?)['\"]", "igm");
		public static const OG_URL:RegExp			= new RegExp("<meta[^>]+property=['\"]+og:url.+['\"]?+content=['\"](.*?)['\"]", "igm");
		public static const OG_IMAGE:RegExp			= new RegExp("<meta[^>]+property=['\"]+og:image.+['\"]?+content=['\"](.*?)['\"]", "igm");
		public static const OG_SITE_NAME:RegExp		= new RegExp("<meta[^>]+property=['\"]+og:site_name.+['\"]?+content=['\"](.*?)['\"]", "igm");
		public static const FB_APP_ID:RegExp		= new RegExp("<meta[^>]+property=['\"]+fb:app_id.+['\"]?+content=['\"](.*?)['\"]", "igm");
		
		public static function getMetaContent(html:String, regExp:RegExp):String
		{
			const CONTENT_LENGTH:uint = "content=\"".length;
			
			var metaString:String = html.match(regExp).join('');
			var rawContent:String = metaString.match(regExp).join('').match(WebSiteRegExp.META_CONTENT).join('');
			return rawContent.substr(CONTENT_LENGTH, rawContent.length - 1 - CONTENT_LENGTH);
		}
	}
}