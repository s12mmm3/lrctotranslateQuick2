#include "operator.h"
#include "lyrichelper.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
// #include <QQuickStyle>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    // QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;

    Operator operator0;
    engine.rootContext()->setContextProperty("$operator", &operator0);

    LyricHelper lyricHelper;
    engine.rootContext()->setContextProperty("$lyricHelper", &lyricHelper);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("lrctotranslateQuick2", "Main");

    return app.exec();
}
