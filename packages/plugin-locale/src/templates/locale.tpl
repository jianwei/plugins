import React from 'react';
import EventEmitter from 'events';
{{#Antd}}
import { ConfigProvider } from 'antd';
{{/Antd}}

{{#MomentLocales.length}}
import moment from 'moment';
{{#MomentLocales}}
import 'moment/locale/{{.}}';
{{/MomentLocales}}
{{/MomentLocales.length}}
import { RawIntlProvider, getLocale, setIntl, getIntl, localeInfo } from './localeExports';

export const event = new EventEmitter();
event.setMaxListeners(5);
export const LANG_CHANGE_EVENT = Symbol('LANG_CHANGE');

export function _onCreate() {
  const locale = getLocale();
  {{#MomentLocales.length}}
  if (moment?.locale) {
    moment.locale(localeInfo[locale]?.momentLocale || 'en');
  }
  {{/MomentLocales.length}}
  setIntl(locale);
}

export const _LocaleContainer = props => {
  const [locale, setLocale] = React.useState(() => getLocale());
  const [intl, setContainerIntl] = React.useState(() => getIntl(locale, true));

  const handleLangChange = (locale) => {
    {{#MomentLocales.length}}
    if (moment?.locale) {
      moment.locale(localeInfo[locale]?.momentLocale || 'en');
    }
    {{/MomentLocales.length}}
    setLocale(locale);
    setContainerIntl(getIntl(locale));
  };

  React.useLayoutEffect(() => {
    event.on(LANG_CHANGE_EVENT, handleLangChange);
    {{#Title}}
    // avoid reset route title
    if (typeof document !== 'undefined' && intl.messages['{{.}}']) {
      document.title = intl.formatMessage({ id: '{{.}}' });
    }
    {{/Title}}
    return () => {
      event.off(LANG_CHANGE_EVENT, handleLangChange);
    };
  }, []);

  {{#Antd}}
  return (
    <ConfigProvider locale={localeInfo[locale]?.antd}>
      <RawIntlProvider value={intl}>{props.children}</RawIntlProvider>
    </ConfigProvider>
  )
  {{/Antd}}

  return <RawIntlProvider value={intl}>{props.children}</RawIntlProvider>;
};
